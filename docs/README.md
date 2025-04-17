# Solución Desafío Técnico DevEx 
La solución para el Desafío Técnico Devex tiene la siguiente estructura directorios
- app: es la aplicación backend construida con nodejs y typescript.
- Consideraciones
  - Se construyo con utilizando buenas prácticas mediante una arquitectura por capas utilizando el principio Solid Single Responsability, por esa razón es que las rutas se encuentran separada de los controller, así como tambien el server se ejecuta en el index y app funciona como una especie de proxy hacia rutas y controladores
  - Para Correr los test se utiliza la Librería Jest
  - Para evaluar errores y sintaxis se utilizó el linter Eslint.
  - Se utilizó una estructura de Dockerfile básica, la cual es bastante funcional pero se puede mejorar dado que se podría convertir multi-stage separando el entorno build del de ejecución de tal manera que no copie independencias necesarias, haciendo la imagen mas liviana.

- infra: dentro de infra construi la IAC(Infrastructure as code) con terraform
- Consideraciones:
  - Dentro de modules construi cada modulo necesario para que la aplicación sea desplegada(ecr, eks, node-group y vpc donde tambíen se definen los CIDR, políticas, etc ), de pudo modularizar mas aún pero en honor al tiempo quedo con la estructura actual la cual tambien es bastante funcional
  - Como Bonus el ECR lo construí de tal manera que sea sencillo agregar un nuevo repositorio dado que solo se necesita agregarlo dentro del arreglo repos que se encuentra en el archivo locals.tf
  - Como Bonus cree el archivo tfvars para que sea posible manejar diferentes ambientes(actualmente solo existe el dev.tfvar pero eso es dado que esto es un desafío y no irá a un ambiente productivo)
- .github/workflows: es el directorio donde se encuentran los pipelines para la solución
- Consideraciones:
    - Construí el pipeline ci-app para instalar dependencias, correr los test, correr linters, hacer el build y push hacia el ECR
    - Construí el pipeline cd-app el cual se ejecuta mediante un trigger siempre y cuando el ci termine en estado completado y sin errores
    - Como bonus construí dos pipeline del tipo dispatch(no se ejecutan mediante eventos si no que manualmente), uno se llama deploy-main-infra, y es el encargado de construir la infraestructura inicial en AWS(los ECR, cluster EKS, etc) y el otro se llama configure-namespace y es para crear namespaces dentro del cluster. Los hice separados porque para una ejecucion inicial aunque incorporé depends-on de todas maneras daba problemas si es que el cluster no estaba del todo construido, pero no es solo una solución parche dado que es una buena práctica tener pipelines apartados de configuración.
    - Como bonus los workflow dispatch permiten recibir inputs manuales, uno es un flag para decidir si es que se ejecuta solo un terraform plan o se ejecuta el apply, lo cual le permitiría a un devops primero correr el plan antes de aplicar.
    - el otro input es un listado con los ambientes, actualmente solo esta habilitado el dev dado que es el que llama al dev.tfvars pero si a futuro hubieran otros ambientes esto permitiría escoger que tfvars se quiere ejecutar y por ende manejar diferentes configuraciones por ambientes


# Otras Consideraciones
- Si bien en el desafío de cara a la seguridad se menciona utilizar Secretos, para este caso utilicé OpenID Connect, es un protocolo de comunicación que se basa en OAUTH 2.0, permite en AWS que un github action pueda asumir un rol y es una práctica recomendada incluso mas que usar secretos y aborda lo que es seguridad de igual manera.
- A lo largo de puntos anteriores mencioné algunos bonus que agregué a la solución, tambien creo que es importante resaltar que usé Helm como gestor de paquetes de Kubernetes, el cual facilita la construcción de los componentes de kubernetes(como deployments, services, configmaps, etc) y se utiliza en el CD
- Los tags de cada imagen se generan desde el CI, por motivos de tiempo no utilicé tag semánticos(Major,Minior, dispatch) pero considero que la forma en que estoy taggeando es bastante funcional y mejor que usar latest.
- si bien la aplicación en si se expone en el puerto 3000, dentro del chart de helm la mapeo al puerto 80.
- Para el mensaje del commit estoy utilizando las buenas practicas de conventional commits: https://www.conventionalcommits.org/en/v1.0.0/, donde el mensaje es "feat: mensaje"
- Se puede haber hecho protected branches y haber protegido master pero en honor al tiempo sería una deuda técnica.

# Pipelines

deploy-main-infra.yaml (manual)
- Es el primer pipeline a ejecutar en caso de que la infrastructura no estuviera creada(para este caso no es así)
- Contiene dos jobs: Terraform Plan y Terraform Apply.
- Terraform Init es para iniciar la configuración de terraform.
- El terraform state y lock se esta gestionando con S3 y Dynamo DB
- El paso de configure AWS credentials from IAM Role (OIDC) es el que asume el rol en AWS para poder construir la infrastructura
- Para este pipeline me encuentro utilizando un feature de Terraform llamado targets, para crear solo los módules que en el target se le indica

configure-namespace.yaml (manual)
- Es el segundo pipeline a ejecutar en caso de que los namespaces no estuvieran creados o se quisiera agregar uno nuevo
- Tiene pasos simalares a deploy-main-infra.yaml pero no usa target, por ende va a considerar cualquier otra configuración que no este abordada en los modulos ya definido en los targets de la infra base.

ci-app.yaml

- funciona en base a demanda cada vez que se hace un push o merge a master.
- contiene los pasos necesarios de un CI como instalación de dependencias, utiliza los script del package.json de la aplicación para ejecutar los test con jest y también el linter.
- Se loguea con AWS similar a los otros pipelines para hacer el push al ECR.

cd-app.yaml
- inicia e instala helm
- ejecuta un Script para cambiar el tag de la imagen en el chart.
- - Se loguea con AWS similar a los otros pipelines para acceder al cluster
- se posiciona en el contexto de kubernetes
- hace el deploy de la aplicación en Kubernetes

# Como probar la aplicación?

- Primero se requiere asumir un rol con el siguiente comando: aws sts assume-role \                                                  
  --role-arn arn:aws:iam::269633716143:role/githubChallengeRole \
  --role-session-name "localSession"
- Se debe setear el contexto de Kubernetes: aws eks update-kubeconfig --name app-blue-eks --region us-east-1
- Se con el output del paso anterior se setean las variables de entorno
export AWS_ACCESS_KEY_ID=ASIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...
- Se ejecuta un port-forward: kubectl port-forward svc/app-node-backend 8080:80 -n backend
- Se ejecuta el curl: curl http://localhost:8080

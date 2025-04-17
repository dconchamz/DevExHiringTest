import { Request, Response } from 'express';

export const helloWorld = (req: Request, res: Response) => {
  res.send('¡Hola Mundo 24!');
};


import { Injectable } from '@nestjs/common';
import { Todo } from '@nx-actions-ecs/todos';

@Injectable()
export class AppService {
  getData(): Todo[] {
    return [
      { message: 'Take out trash', done: false },
      { message: 'Continue using Nx', done: false },
    ];
  }
}

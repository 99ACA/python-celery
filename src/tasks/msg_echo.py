import os
import celery
from celery import shared_task


@shared_task(bind=True,name="msg-echo.task")
def print_message(self,arg,message):
    # task.request - https://docs.celeryproject.org/en/stable/userguide/tasks.html#task-request
    print(f"[p-{os.getpid()}] -[{self.request.correlation_id}]--{self.request} -  {arg} - {message}")
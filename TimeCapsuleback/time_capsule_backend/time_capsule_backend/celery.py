import os
from celery import Celery
from celery.schedules import crontab

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'time_capsule_backend.settings')

app = Celery('time_capsule_backend')

app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')



app.conf.beat_schedule = {
    'check_and_send_capsules_every_minute': {
        'task': 'capsules.tasks.check_and_send_capsules',
        'schedule': crontab(),  # каждую минуту
    },
}
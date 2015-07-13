from django.contrib import admin
from coverage.models import event

# Register your models here.
class eventAdmin(admin.ModelAdmin):
    list_display = ['event_type.name', 'location', 'start_date']

admin.site.register(event, eventAdmin)

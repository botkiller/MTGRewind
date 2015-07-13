from django.contrib import admin
from coverage.models import event, format, event_type, organizer, format_type

# Register your models here.
class eventAdmin(admin.ModelAdmin):
    list_display = ['location', 'start_date']

admin.site.register(event, eventAdmin)

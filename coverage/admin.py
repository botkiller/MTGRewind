from django.contrib import admin
from coverage.models import event, format, event_type, organizer, format_type

# Register your models here.
class eventAdmin(admin.ModelAdmin):
    list_display = ['get_event_type', 'location', 'start_date']
    def get_event_type(self, obj):
        return obj.event_type.name
    get_event_type.short_description = "Event Type"

admin.site.register(event, eventAdmin)

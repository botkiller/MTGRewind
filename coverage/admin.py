from django.contrib import admin
from coverage.models import event, match, game, deck, format, organizer, player, format_type, archetype, event_type, color, archetype_image, commentator

# Register your models here.
class eventAdmin(admin.ModelAdmin):
    list_display = ['get_event_type', 'location', 'start_date']
    def get_event_type(self, obj):
        return obj.event_type.name
    get_event_type.short_description = "Event Type"

admin.site.register(event, match, game, deck, format, organizer, player, format_type, archetype, event_type, color, archetype_image, commentator, eventAdmin)

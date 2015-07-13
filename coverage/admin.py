from django.contrib import admin
from coverage.models import event, match, game, deck, format, organizer, player, format_type, archetype, event_type, color, commentator

# Register your models here.
class eventAdmin(admin.ModelAdmin):
    list_display = ['get_event_type', 'location', 'start_date']
    def get_event_type(self, obj):
        return obj.event_type.name
    get_event_type.short_description = "Event Type"

admin.site.register(event,eventAdmin)
admin.site.register(match)
admin.site.register(game)
admin.site.register(deck)
admin.site.register(format)
admin.site.register(organizer)
admin.site.register(player)
admin.site.register(format_type)
admin.site.register(archetype)
admin.site.register(event_type)
admin.site.register(color)
admin.site.register(commentator)

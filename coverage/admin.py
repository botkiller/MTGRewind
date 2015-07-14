from django.contrib import admin
from coverage.models import event, match, game, deck, format, organizer, player, format_type, archetype, event_type, color, commentator

# Register your models here.
class MatchInLine(admin.TabularInline):
    model = match
    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        field = super(MatchInLine, self).formfield_for_foreignkey(db_field, request, **kwargs)

        if db_field.name == 'event_id':
            if request._obj_ is not None:
                field.queryset = field.queryset.filter(event__exact = request._obj_)
            else:
                field.queryset = field.queryset.none()
        return field

class eventAdmin(admin.ModelAdmin):
    list_display = ['get_event_type', 'location', 'start_date']
    inlines = (MatchInLine,)

    def get_form(self, request, obj=None, **kwargs):
        request._obj_ = obj
        return super(eventAdmin, self).get_form(request, obj, **kwargs)
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

from django.contrib import admin
import coverage.models

# Register your models here.
class eventAdmin(admin.ModelAdmin):
    list_display = ['location', 'start_date']

admin.site.register(event, eventAdmin)

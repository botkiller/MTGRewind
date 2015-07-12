from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'django_project.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^$', 'MTGRewind.coverage.views.home', name='home'),
    url(r'^(?P<event_id>[0-9]+)/$','MTGRewind.coverage.views.eventdetail', name='eventdetail'),
    url(r'^admin/', include(admin.site.urls)),
)

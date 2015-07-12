# Create your views here.
from django.shortcuts import render_to_response
from coverage.models import event, match

def home(request):
    entries = event.objects.order_by('-start_date')[:10]
    return render_to_response('coverage/index.html', {'events' : entries})

def eventdetail(request, event_id):
    entries = match.objects.filter(event = event_id).order_by('round_number')
    evt = event.objects.filter(pk = event_id)
    return render_to_response('coverage/event.html', {'matches' : entries, 'events' : evt})

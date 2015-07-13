from django.db import models

class event(models.Model):
    event_type = models.ForeignKey('coverage.event_type')
    start_date = models.DateField()
    end_date = models.DateField()
    location = models.CharField(max_length=100)
    organizer = models.ForeignKey('coverage.organizer')
    rounds = models.IntegerField()
    format = models.ForeignKey('coverage.format')
    winning_deck = models.ForeignKey('coverage.deck', blank=True, null=True)
    details_url = models.CharField(max_length=255, blank=True, null=True)

class match(models.Model):
    event = models.ForeignKey('coverage.event')
    vod_url = models.CharField(max_length=255)
    round_number = models.IntegerField(blank=True, null=True)
    top8 = models.CharField(max_length=50,blank=True, null=True)
    first_deck = models.ForeignKey('coverage.deck', related_name='first_deck')
    first_deck_wins = models.IntegerField(blank=True, null=True)
    first_deck_losses = models.IntegerField(blank=True, null=True)
    second_deck = models.ForeignKey('coverage.deck', related_name='second_deck')
    second_deck_wins = models.IntegerField(blank=True, null=True)
    second_deck_losses = models.IntegerField(blank=True, null=True)
    winning_deck = models.ForeignKey('coverage.deck', related_name='deck_match_win',blank=True, null=True)

class game(models.Model):
    match = models.ForeignKey('coverage.match')
    game_number = models.IntegerField()
    vod_url_start = models.IntegerField()
    winning_deck = models.ForeignKey('coverage.deck', related_name='deck_game_win')
    losing_deck = models.ForeignKey('coverage.deck', related_name='deck_game_loss')

class deck(models.Model):
    name = models.CharField(max_length=100)
    archetype = models.ForeignKey('coverage.archetype')
    player = models.ForeignKey('coverage.player')
    format = models.ForeignKey('coverage.format')
    color = models.ForeignKey('coverage.color', blank=True, null=True)


    def __unicode__(self):
        return self.name + " test "

class format(models.Model):
    name = models.CharField(max_length=100)
    format_type = models.ForeignKey('coverage.format_type')
    epoch = models.ForeignKey('coverage.epoch', blank=True, null=True)
    def __unicode__(self):
        return self.name

class organizer(models.Model):
    name = models.CharField(max_length=100)
    def __unicode__(self):
        return self.name

class player(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    team = models.CharField(max_length=100, blank=True, null=True)
    twitter = models.CharField(max_length=100, blank=True, null=True)
    picture = models.CharField(max_length=255, blank=True, null=True)
    pro_tour_wins = models.IntegerField( blank=True, null=True)
    pro_tour_top8s = models.IntegerField( blank=True, null=True)
    grand_prix_wins = models.IntegerField( blank=True, null=True)
    grand_prix_top8s = models.IntegerField( blank=True, null=True)
    world_championships = models.IntegerField( blank=True, null=True)

class format_type(models.Model):
    name = models.CharField(max_length=100)

class epoch(models.Model):
    name = models.CharField(max_length=100)

class archetype(models.Model):
    name = models.CharField(max_length=100)

class event_type(models.Model):
    name = models.CharField(max_length=100)
    def __unicode__(self):
        return self.name

class color(models.Model):
    name = models.CharField(max_length=100)
    is_white = models.BooleanField()
    is_blue = models.BooleanField()
    is_black = models.BooleanField()
    is_red = models.BooleanField()
    is_green = models.BooleanField()

class archetype_image(models.Model):
    color = models.ForeignKey('coverage.color')
    archetype = models.ForeignKey('coverage.archetype')
    image_location = models.CharField(max_length=255)

class commentator(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)

class analysis(models.Model):
    match = models.ForeignKey('coverage.match')
    first_commentator = models.ForeignKey('coverage.commentator', related_name = 'color_commentator')
    second_commentator = models.ForeignKey('coverage.commentator', related_name = 'play_commentator')
    commentary_rating = models.IntegerField()
    play_rating = models.IntegerField()

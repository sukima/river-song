# Description
#   Allows you to query images and info about this bot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot about|about me|who are you - Gives a little about your bot
#   hubot what do you look like|picture of yourself|picture - Shows an image of your bot
#
# Notes:
#   This is specific to this bot. You will have to heavily modify this for your
#   own bot/personality.
#
# Author:
#   @sukima
images = [
  "http://rohan-prakash.com/blog/wp-content/uploads/2011/09/River-Song.jpeg#.jpg"
  "http://4.bp.blogspot.com/_FRI8NZ068sE/TIY0H0IQAOI/AAAAAAAABf4/2yP0FecuhEU/s1600/s4_08_river-song.jpg"
  "http://4.bp.blogspot.com/-QVx23pEOFnQ/UIqKreLcbRI/AAAAAAAADSs/qy5CENB4JAs/s1600/471493-river_song.png"
  "http://3.bp.blogspot.com/-WgvW-zz00dk/TdDvwxN8ovI/AAAAAAAAAIQ/K5NH1HU_hWA/s1600/River_Song_letter.png"
  "http://www.supanova.com.au/wp-content/uploads/2013/03/river-song-alex-kingston-4.jpg"
  "http://2.bp.blogspot.com/_45CQ84jr9DQ/S-wz7ERj6xI/AAAAAAAABdk/M6i4aK-kbqQ/s1600/river-song-angels-still.jpg"
  "http://24.media.tumblr.com/tumblr_m4aolb0I0r1qbm00wo1_1280.jpg"
  "http://nenya1985.roadnet.de/e107_plugins/sgallery/pics/1n8ze54vythz/riversong1.jpg"
]

sendBio = (msg) ->
  msg.send """
    I am a mysterious archaeologist and convicted murderer who shared a close
    relationship with the Doctor.
    http://riversongwebsite.blogspot.com/p/bio.html
  """

sendImage = (msg) ->
  msg.send msg.random images

module.exports = (robot) ->
  robot.respond ///
    about ( \s* me | \s+ you ( rself )? | \s+ self )?
    |
    who \s+ ( are|r ) \s+ ( you|u )
  ///i, sendBio
  robot.respond ///
    what \s+ do \s+ you \s+ look \s+ like
    |
    ( show \s+ (\s+me (\s+a)? )? )? ( pic(ture)? ) (\s+of)? \s+ ( yourself | self )
    |
    pic(ture)? $
  ///i, sendImage

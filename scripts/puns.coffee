# Description:
#   Offer a pun to the user.
#
# Dependencies:
#   None
#
# Configuration:
#   PUN_ME_DELAY - How long to wait to send the pun answer (default: 5000)
#
# Commands:
#   hubot pun me
#
# Author:
#   sukima

ANSWER_DELAY = process.env.PUN_ME_DELAY ? 5000

# The text is wrapped in quotes (")
# If the text contains a quote place a back-slash in front ("this string \"has quotes\".")
# A pun that has a question then ann answer looks like:
#     {question: "What is?", answer: "That is!"}
# A pun that is just a one off pun looks like this:
#     {text: "Oh how punny this is."}
PUNS = [
  {text: "The best way to communicate with a fish is to drop them a line."}
  {text: "He bought a donkey because he thought he might get a kick out of it."}
  {text: "In the winter my dog wears his coat, but in the summer he wears his coat and pants."}
  {text: "Time flies like an arrow. Fruit flies like a banana."}
  {text: "A chicken crossing the road is poultry in motion."}
  {text: "Energizer Bunny arrested -- charged with battery."}
  {text: "A skunk fell in the river and stank to the bottom."}
  {text: "The chicken crossed the playground to get to the other slide."}
  {text: "The best way to stop a charging bull is to take away his credit card."}
  {text: "The marine biology seminars weren’t for entertainment, but were created for educational porpoises."}
  {text: "The screwdriver was close the a screw. The screw said \"Screw this, I'm out!\""}
  {text: "Becoming a vegetarian is a big missed steak."}
  {question: "Where do polar bears vote?", answer: "The North Poll."}
  {question: "How do turtles talk to each other?", answer: "By using shell phones!"}
  {question: "Why are teddy bears never hungry?", answer: "They are always stuffed!"}
  {question: "Why did the spider go to the computer?", answer: "To check his web site."}
  {question: "Why are playing cards like wolves?", answer: "They come in packs."}
  {question: "What do you get when you cross a snake and a pie?", answer: "A pie-thon!"}
  {question: "What was the reporter doing at the ice cream shop?", answer: "Getting the scoop!"}
  {question: "What do you call a sleeping bull?", answer: "A bull-dozer."}
  {question: "What do baseball players eat on?", answer: "Home plates!"}
  {question: "Why did the turkey cross the road?", answer: "To prove he wasn't chicken!"}
  {question: "Why do fish live in salt water?", answer: "Because pepper makes them sneeze!"}
  {question: "What did the judge say when the skunk walked into the court room?", answer: "Odor in the court!"}
  {question: "How do you fix a broken tomato?", answer: "With tomato paste."}
  {question: "Why did the lion spit out the clown?", answer: "Because he tasted funny!"}
  {question: "What's purple and 5000 miles long?", answer: "The Grape Wall of China!"}
  {question: "What do you call a knight who is afraid to fight?", answer: "Sir Render."}
  {question: "Why are fish so smart?", answer: "Because they live in schools."}
  {question: "What do you get from a pampered cow?", answer: "Spoiled milk."}
  {question: "What did the blanket say when it fell off the bed?", answer: "Oh sheet!"}
  {question: "Who gets rid of eggs?", answer: "The eggs-terminater!"}
  {question: "Q: what did the baby corn tell to the mama corn?", answer: "A: wheres pop-corn."}
  {question: "What did the buffalo say when his son went off to college?", answer: "Bison."}
  {question: "What do you get when dinosaurs crash their cars?", answer: "T-Rex."}
  {question: "How do you put a baby alien to sleep?", answer: "You rocket."}
  {question: "What do you call a cow with no legs?", answer: "Ground beef."}
  {question: "What do you call a lazy kangaroo?", answer: "A Pouch Potato!"}
  {question: "What job did the frog have at the hotel?", answer: "Bellhop!"}
  {question: "What has eyes but cannot see?", answer: "A Potato!"}
  {question: "What do you call a bear with no teeth?", answer: "A gummy bear!"}
  {question: "What do you call an everyday potato?", answer: "A commontater."}
  {question: "What do you call an alligator in a vest?", answer: "An Investigator!"}
  {question: "How do you organize a space party?", answer: "You planet!!"}
  {question: "What did the tennis ball say to the other tennis ball?", answer: "See you round!"}
]

REACTIONS = [
  "Yowzah! :grinning:"
  ":stuck_out_tongue_closed_eyes:"
  "Bada-Bing Bada-Boom :boom:"
  "Yuck Yuck Yuck"
  "…Oh that's a gem :gem:"
  "ba-dum ching!"
]

sendMsgReaction = (msg, text) -> ->
  msg.send "#{text} #{msg.random REACTIONS}"

module.exports = (robot) ->
  robot.respond /((show|give) me (a )?)?pun( me)?/i, (msg) ->
    pun = msg.random PUNS
    if pun.text
      sendMsgReaction(msg, pun.text or pun)()
    else
      msg.send pun.question
      setTimeout sendMsgReaction(msg, pun.answer), ANSWER_DELAY

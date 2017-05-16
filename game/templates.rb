def build_quick_reply(txt)
  template = { text: txt, quick_replies: [] }
  yield template
  template
end

def build_image_response(image_url)
  {
    attachment: {
      type: "image",
      payload: {
        url: image_url
      }
    }
  }
end


def send_image(image_url, response_obj)
  response_obj.reply(build_image_response(image_url))
end

def send_choose_marker_prompt(msg)
  msg.reply(text: "Lets get started on a new game")

  reply = build_quick_reply("Choose your marker") do |payload|
    payload[:quick_replies] = [
      {
        content_type: "text",
        title: " plays first",
        payload: "X",
        image_url: "http://www.drodd.com/images14/x16.png"
      },
      {
        content_type: "text",
        title: " plays second",
        payload: "O",
        image_url: "https://goo.gl/ltLUey"
      }
    ]
  end
  msg.reply(reply)
end

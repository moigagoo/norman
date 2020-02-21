import terminal, os

const frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]

type
  MessageKind = enum
    update, success, failure
  Message = object
    kind: MessageKind
    text: string
  Spinner* = object
    channel: Channel[Message]
    thread: Thread[Spinner]

proc render(spinner: Spinner) =
  var
    msg:Message
    i: Natural

  while true:
    case peek spinner.channel
    of -1: return
    of 1..high(int): msg = spinner.channel.recv()
    else: discard

    flushFile stdout
    eraseLine()

    case msg.kind
    of update:
      stdout.styledWrite(frames[i], resetStyle, " " & msg.text)
      i = (i+1) mod len(spinner)
      sleep 80
    of success:
      stdout.styledWrite("✔", " " & msg.text)
      return
    of failure:
      stdout.styledWrite("❌", " " & msg.text)
      return

proc initSpinner*(): Spinner =
  open result.channel
  createThread(result.thread, render, result)


when isMainModule:
  let s = initSpinner()

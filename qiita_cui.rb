require 'curses'
require './get_info'
Curses.init_screen

uri = "http://qiita.com/"
word = "ruby"
sort = 'items'
page = 1
height = 25
width = 120

def set_view(win, word, sort, page)
  win.clear
  y=1
  win.setpos(y,2)
  str = "Page:" + page.to_s.rjust(3)
  win.addstr(str)
  y+=1
  win.setpos(y,2)
  list = get_info(word, sort, page.to_s)
  list.each do |node|
    win.addstr("  "+node.inner_text+"\n")
    win.setpos(y,2)
    y+=1
  end
  win.setpos(22,2)
  if sort == "items"
    str = "[sort: " + "newest ]"
  else
    str = "[sort: " + "likes  ]"
  end
  win.addstr(str)
  win.setpos(23,2)
  str = "Search Word: " + word.ljust(15)
  win.addstr(str)
  win.box(?|,?-,?+)
  win.refresh
  return list
end

begin
  win = Curses::Window.new(height, width, 1, 1)# 行数, 文字数(列数), padding-top, padding-left
  x=2
  y=2

  list = set_view(win, word, sort, page)

  win.box(?|,?-,?+) # 境界線の指定 縦,横,角
  Curses::noecho
  win.refresh
  key=""
  win.setpos(2,2)
  while(key!='q') do

    win.setpos(height-1, 10)
    str = "[ UP:p Down:n Next-Page:f Previous-Page:b Quit:q ]"
    win.addstr(str)
    win.setpos(y,x)

    key = win.getch

    if key == "f" # 右
      page+=1
      list = set_view(win, word, sort, page)
    end

    if key == "b" # 左
      if page>1
        page-=1
        list = set_view(win, word, sort, page)
      end
    end

    if key == "p" # 上
      if y>2
        y-=1
      end
    end

    if key == "n" # 下
      if y<height-2
        y+=1
      end
    end

    if key== Curses::KEY_CTRL_J
      if y.between?(1,19)
        url = uri + list[y-1].css("a")[0][:href]
        
        system("open", url)
      elsif y == height-3
        if sort == "items"
          sort = "likes"
        else
          sort = "items"
        end
        page = 1
        list = set_view(win, word, sort, page)
      elsif y == height-2
        win.setpos(y,15)
        Curses::echo
        word = win.getstr()
        word.chomp
        Curses::noecho
        page = 1
        list = set_view(win, word, sort, page)
      end
    end

  end

  win.close
ensure
  Curses.close_screen
end

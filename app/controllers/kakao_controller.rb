require 'parse' #helper안에 있는 파일을 자동으로 찾아줌

class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
      :type => "text"
    }
    render json: home_keyboard
  end

  def message
      image = false
      user_message = params[:content]

      if user_message == '메뉴'
        menus = ["20층","시골집","편의점","시래기","중국집"]
        bot_message = menus.sample
      elsif user_message == '로또' || user_message == "일주일의행복"
        array = (1..45).to_a
        bot_message = array.sample(6).sort.to_s
      elsif user_message == '고양이' || user_message == "ㄱㅇㅇ"
        image = true
        parser = Parse::Animal.new  #:: class표현
        bot_message = parser.cat[0]
        img_url = parser.cat[1]

      elsif user_message == '영화'
        image = true
        parser = Parse::Movie.new

        one_movie = parser.naver
        bot_message = one_movie[0]
        img_url = one_movie[1]
        # doc.css('div.start_t1 span').each do |movie| # 주소 의미?>? html xpath xml
        #   movie_star << movie.css('num').integer
        # end
        # bot_message = movie_star.sample

      # elsif user_message == '원소'
      #   url = "https://ko.wikipedia.org/wiki/"
      #   element_html = RestClient.get(url)
      #   doc = Nokogiri::HTML(element_html)
      #
      #   element_list = Array.new
      #   doc.css('table.infobox tr').each do |element|
      #     element_html << element.css('tr td').text
      #
      #   bot_message = element_list
      elsif user_message[0] == '!'
        keyword = user_message[1..-1]
        # url = "https://ko.wikipedia.org/wiki/#{keyword}"
        # response = RestClient.get(URI.encode(url))
        # doc = Nokogiri::HTML(response)
        # elementType = doc.css("table.infobox").children[9].text.strip.split[2]
        # bot_message = elementType

        url = "https://ko.wikipedia.org/wiki/%EC%9B%90%EC%86%8C_%EB%AA%A9%EB%A1%9D"
        response = RestClient.get(url)
        doc = Nokogiri::HTML(response)
        doc.css('table.sortable tr').each do |o|
          # o.css('td')[3].css('a').text
        oo = o.css('td')[2]
        if !oo.nil?
          puts oo.css('a').text
        end

        end


      else
        bot_message = "해당 기능은 지원하지 않습니다."
      end
      #bot_message = movie_list.sample

      return_message = {
        :message => {
            :text => bot_message
          },
        :keyboard => {
            :type => "text"
        }
      }

      return_message_with_img = {
        :message => {
          :text => bot_message,
          :photo => {
            :url => img_url,
            :width => 640,
            :height => 480
            }
          },
        :keyboard => {
          :type => "text"
        }
      }
      if image == true
        render json: return_message_with_img
      else
        render json: return_message
      end
  end
end

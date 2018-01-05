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
    else
      bot_message = "해당 기능은 지원하지 않습니다."
    end

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

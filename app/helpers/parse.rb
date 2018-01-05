module Parse
  class Movie
    def naver
      url = "http://movie.naver.com/movie/running/current.nhn"
      movie_html = RestClient.get(url)
      doc = Nokogiri::HTML(movie_html)

      movie_list = Array.new
      movies = Hash.new

      doc.css('ul.lst_detail_t1 li').each do |movie| # 주소 의미?>? html xpath xml
        movie_title = movie.css('dt a').text
        movie_list << movie_title

        movies[movie_title] = { #해쉬 형태, key: star , value
          :star => movie.css('dl.info_star span.num').text, #dl안에 info_star클래스 , span안에 num클래스
          #dd class    dd라는 속성을가진 star 클래스  html은 id나 class가짐 id는 #id
          :url => movie.css('div.thumb img').attribute('src').to_s
        }
      end
      sample_movie = movie_list.sample
      bot_message = sample_movie + " 평점:" + movies[sample_movie][:star]
      img_url = movies[sample_movie][:url]

      return [bot_message, img_url]
    end
  end

  class Animal
    def cat
      bot_message = "나만 고양이 없어"
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      img_url = doc.xpath("//url").text

      return [bot_message, img_url]
    end
  end
end

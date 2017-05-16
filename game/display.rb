require "squib"
require "cloudinary"

module Game
  class Display
    COLORS = { player: "green", cpu: "red", default: "#0000" }.freeze

    def initialize(user_marker, cpu_marker)
      @user_marker = user_marker
      @cpu_marker = cpu_marker
    end

    def display(values)
      this = self
      response = ""
      Squib::Deck.new width: 300, height: 300, cards: 1 do
        background color: "#808080"

        i = 1

        0.step(200, 100) do |y|
          0.step(200, 100) do |x|
            xter = values[i.to_s]
            xter = i if xter.empty?
            rect x: x, y: y, width: 100, height: 100, fill_color: this.fill_color(xter)

            padding = this.display_padding_for(xter)
            text str: xter,
                 color: "#F3EFE3",
                 font: "Sans italic 18",
                 x: x + padding,
                 y: y + padding,
                 font_size: this.display_font_size(xter)
            i += 1
          end
        end

        save_png
        image_path = "_output/card_00.png"
        response = this.upload_to_cloudinary(image_path)
        this.delete_image(image_path)
        return response["secure_url"]
      end
    end

    def is_player_xter?(xter)
      xter == @user_marker
    end

    def is_cpu_xter?(xter)
      xter == @cpu_marker
    end

    def display_padding_for(xter)
      index_placeholder_xter?(xter) ? 70 : 20
    end

    def display_font_size(xter)
      index_placeholder_xter?(xter) ? 20 : 50
    end

    def index_placeholder_xter?(xter)
      !(%w[X O].include? xter)
    end

    def fill_color(xter)
      if is_player_xter?(xter)
        COLORS.fetch(:player)
      elsif is_cpu_xter?(xter)
        COLORS.fetch(:cpu)
      else
        COLORS.fetch(:default)
      end
    end

    def upload_to_cloudinary(image_path)
      Cloudinary::Uploader.upload(image_path, cloudinary_auth)
    end

    def cloudinary_auth
      {
        cloud_name: ENV["CLOUDINARY_CLOUD_NAME"],
        api_key: ENV["CLOUDINARY_API_KEY"],
        api_secret: ENV["CLOUDINARY_API_SECRET"]
      }
    end

    def delete_image(path_to_image)
      File.delete(path_to_image) if File.exist?(path_to_image)
    end
  end
end

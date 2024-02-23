module ColorableString
  RGB_COLOR_MAP = {
    cyan: "139;233;253",
    green: "80;250;123",
    red: "255;85;85"
  }.freeze

  refine String do
    def fg_color(color_name)
      rgb_val = RGB_COLOR_MAP[color_name]
      "\e[38;2;#{rgb_val}m#{self}\e[0m"
    end
  end
end
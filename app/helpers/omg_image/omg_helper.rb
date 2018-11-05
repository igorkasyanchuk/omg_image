module OmgImage
  module OmgHelper
    COLORS = [
      {
        bg: "#19063A",
        text: "#dce9f3",
      },
      {
        bg: "#080E3B",
        text: "#ffffff",
      },
      {
        bg: "#010C1F",
        text: "#aebcd5",
      },
      {
        bg: "#d7dee2",
        text: "#022235",
      },
      {
        bg: "#161616",
        text: "#66e2d5",
      },
      {
        bg: "#1c0bba",
        text: "#c9d2dd",
      },
      {
        bg: '#449833',
        text: '#fff'
      },
      {
        bg: '#f31e25',
        text: '#fff'
      },
      {
        bg: '#f5681d',
        text: '#fff'
      },
      {
        bg: '#3d9fe1',
        text: '#fff'
      },
      {
        bg: '#930b99',
        text: '#fff'
      },
      {
        bg: '#f2169a',
        text: '#fff'
      },
    ].shuffle.freeze

    def assigned_color(id = rand(COLORS.size))
      COLORS[id % COLORS.size]
    end
  end
end
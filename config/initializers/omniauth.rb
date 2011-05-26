Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'BCVUEJ8YM7td7YPCLLH8Zg', 'pFEnMwiPhbm44zlccQt2Kz7SB1PpHt8DkLcFZ27ItWo'
  provider :facebook, 'c6607762fe7f1a28b5bdb35701b55f12', '7f574c2d0266f3a1db262802ab71e9b1', {:scope => 'manage_pages'}
  provider :tumblr, 'JxCIF1tJaiqqJmiU4vdK7w0U4OwVuKGQfMgy8yib66b8Lwzma4', 'LScN6lBogvYkZKI80uWS5EfFtAElen3XncXXIrFux1kBmgT2Fy'

end
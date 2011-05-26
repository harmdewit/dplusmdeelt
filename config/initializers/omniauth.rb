Rails.application.config.middleware.use OmniAuth::Builder do

  if Rails.env.development?
    provider :twitter, 'BCVUEJ8YM7td7YPCLLH8Zg', 'pFEnMwiPhbm44zlccQt2Kz7SB1PpHt8DkLcFZ27ItWo'
    provider :facebook, 'c6607762fe7f1a28b5bdb35701b55f12', '7f574c2d0266f3a1db262802ab71e9b1', {:scope => 'manage_pages'}
    provider :tumblr, 'JxCIF1tJaiqqJmiU4vdK7w0U4OwVuKGQfMgy8yib66b8Lwzma4', 'LScN6lBogvYkZKI80uWS5EfFtAElen3XncXXIrFux1kBmgT2Fy'
  elsif Rails.env.production?
     provider :twitter, 'rN9LiKlovzzbSrWuL89aTw', 'PEs8uvscOfJtGVUSbMySiZtEnM7fF2bW9BPznRlE'
      provider :facebook, '3a210cc61ff613d5a2447572b20b0339', 'c70b54036fcb8db20e06b28dc504b61a', {:scope => 'manage_pages'}
      provider :tumblr, 'huH9VMjZ5W2aFYNPnaAUslD39AuMSlxjJTFdbX7xO06rINSwFv', 'CgoYqeFZe2C9E3j1jUsJCRHhmrYBzQZX1IVKnDnk9mDmZ4ik6F'
  end

end
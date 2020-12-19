 def faker_fullname()
  firstname  = ["Salis", "Syauqi", "Rahmat", "Taufik", "Fajar", "Reyhan"].sample
  lastname = ["Mahmudah", "Sugara", "Ramadhan", "Anasya", "Willis"].sample

  fullname = firstname + " " + lastname
end

def faker_email()
  provider = ["hotmail","rocketmail","ymail","gmail"].sample
  username = faker_fullname.downcase.delete(' ') + Random.new.rand(1000).to_s
  email = username + "@" + provider + ".com"
end

def faker_country()
  country = ["Indonesia","Afghanistan","Aruba","Angula"].sample
end

def faker_title()
  title = ["Tuan","Nyonya","Nona"].sample
end

def faker_phone_number(prefix)
  prefix + rand.to_s[3..9]
end

def faker_identity_number()
  16.times.map { rand(1..9) }.join
end
 
def normalize_price(amount)
  nominal = amount.delete('IDR ')
  nominal.delete('.').to_i
end

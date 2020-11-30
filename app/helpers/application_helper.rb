module ApplicationHelper
  def user_avatar(user)
    user.avatar_url.present? ? user.avatar_url : asset_path('avatar.jpg')
  end

  def declension(number, one, few, many)
    remainder_10 = number % 10

    return many if (11..14).include?(number % 100)
    return one if remainder_10 == 1
    return few if (2..4).include?(remainder_10)

    many
  end
end

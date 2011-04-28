module ApplicationHelper


  def tickets_to_assign(departments)
    Ticket.where(:department_id => departments,:assigned_to=>nil)
  end

  #returns path of the requested size image.
  #if image is not there, then
  def get_user_image(user,size)
    if img=user.image
        img.photo.url(size)
    else
        '/images/default-user-image-'+size.to_s+'.jpg'
    end
  end

  def is_head_of_any_dept?(user)
    Department.find_by_head_id(user.id) ? true : false
  end

end

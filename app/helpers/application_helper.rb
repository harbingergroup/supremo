module ApplicationHelper


def tickets_to_assign(departments)
  Ticket.where(:department_id => departments,:assigned_to=>nil)
end

end

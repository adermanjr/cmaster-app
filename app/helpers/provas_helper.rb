module ProvasHelper
  def class_pill(proprio_result, default)
    if proprio_result 
      'primary'
    else
      default
    end
  end
end

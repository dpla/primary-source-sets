FactoryGirl.define do
  factory :image_factory, class: Image do
    file_name 'picture-of-little-my'
    size 'large'
    alt_text 'picture of Little My'
  end

  factory :invalid_image_factory, class: Image do
    file_base nil
    mime_type nil
  end
end

FactoryGirl.define do
  factory :guide_factory, class: Guide do
    name 'Exploring Moominvalley'
    questions 'The birthday button: so good or no good?'
    activity 'Discuss the birthday button'
    association :source_set, factory: :source_set_factory
  end

  factory :invalid_guide_factory, class: Guide do
    name nil
  end

  factory :published_guide_factory, class: Guide do
    name 'Contemplating Guides'
    questions 'What makes this guide such a joy to follow?'
    activity 'Praise the author of this test guide.'
    association :source_set, factory: :published_source_set_factory
  end
end

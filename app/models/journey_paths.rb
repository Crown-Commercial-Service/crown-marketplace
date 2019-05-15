class JourneyPaths
  include Rails.application.routes.url_helpers

  def initialize(journey_name)
    @journey_name = journey_name
  end

  def home
    homepage_path
  end

  def question(slug, params = nil)
    if params
      if slug
        journey_question_path(journey: @journey_name,
                              slug: slug,
                              params: params)
      else
        journey_question_path(journey: @journey_name,
                              slug: 'sorry',
                              params: params)
      end
    else
      journey_question_path(journey: @journey_name,
                            slug: slug)
    end
  end

  def answer(slug)
    journey_answer_path(journey: @journey_name, slug: slug)
  end
end

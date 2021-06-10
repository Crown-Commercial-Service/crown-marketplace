class JourneyPaths
  include Rails.application.routes.url_helpers

  def initialize(journey_name)
    @journey_name = journey_name
  end

  def home
    homepage_path
  end

  def question(framework, slug, params = nil)
    if params
      if slug
        journey_question_path(journey: @journey_name,
                              framework: framework,
                              slug: slug,
                              params: params)
      else
        journey_question_path(journey: @journey_name,
                              framework: framework,
                              slug: 'sorry',
                              params: params)
      end
    else
      journey_question_path(journey: @journey_name,
                            framework: framework,
                            slug: slug)
    end
  end

  def answer(framework, slug)
    journey_answer_path(journey: @journey_name, framework: framework, slug: slug)
  end
end

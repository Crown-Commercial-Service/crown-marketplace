module Apprenticeships
  class HomeController < FrameworkController
    require_permission :none, only: :index
    before_action :set_back_path, except: :index

    def index; end

    def search; end

    def search_results; end

    def training_provider
      require 'ostruct'
      @provider = OpenStruct.new(
        title: 'ABC Training LTD',
        email: 'emailaddress@websiteurl.ac.uk',
        phone: '01234 567890',
        website: 'http://websiteurl.ac.uk',
        address: 'Maidstone Campus, Tonbridge Road, Maidstone, Kent, ME16 8AQ',
        about_apprenticeship: 'This professionally accredited course aims to equip you with the knowledge, technical and practical skills and techniques required for a successful career as a building services engineer, able to respond to environmental and ethical considerations, while talking into consideration relevant social and economic implications too.
                ABC Training LTD has a long and prestigious engineering heritage and is ranked 2nd for \'Mechanical Engineering\', 10th for \'Civil Engineering\' and 30th for \'Electronic and Electrical Engineering\' by the Guardian University Guide 2018. We enjoy a strong portfolio of industry-related research, particularly in the areas of low carbon building technology, sustainable construction materials and engineering education',
        apprenticeship: 'Building services design engineer',
        ofsted_apprenticeship: '2 - Good',
        level: 6,
        duration: '24 months',
        funding_band: 'At funding band maximum',
        ability_to_bespoke: 'Yes',
        experience_in_this_apprenticeship: 'Yes',
        day_release: true,
        block_release: true,
        at_your_location: false,
        classroom_based: true,
        online: true,
        workplace_based: false,
        blended: true,
        classroom_sharing_open: false,
        classroom_sharing_closed: true,
        classroom_sharing_public: false,
        training_availability_open: false,
        training_availability_closed: true,
        training_availability_public: false,
        overall_ofsted: '1 - Outstanding',
        experience_in_delivering_apprenticeships: "Yes",
        recruitment_support: "Yes",
        about_provider: 'University of the Year for Student Experience; latest Times and Sunday Times league table
                         Ranked No.13 UK University; Guardian University Guide 2018
                         Gold for outstanding teaching and learning; Teaching Excellence Framework 2017
                         ABC Training LTD apprenticeships are pleased to offer the opportunity to upskill employees with a range of higher and degree apprenticeships enable people of all ages to earn a wage while studying for a higher-level qualification.
                         With ABC Training LTD, apprentices can gain professional qualifications as well as academic qualifications.',
        apprenticeships_standards: ['Construction Building: Woodmachining',
                                    'Construction Technical and Professional: Building Control',
                                    'Construction Building: Trowel Occupations',
                                    'Facilities Management: Building Services',
                                    'Building Services Engineering Installer',
                                    'Building Services Engineering Ductwork Craftsperson']
      )
    end

    private

    def set_back_path
      @back_path = :back
    end

  end
end

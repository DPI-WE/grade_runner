namespace :grade_runner do
  desc "Grade project"
  task runner: :environment do
    default_submission_url = "https://grades.firstdraft.com"
    config = {}
    path = Rails.root.join("grades.yml")
    if File.exist?(path)
      config = YAML.load_file(path)
    end
    rspec_output_json = JSON.parse(File.read("#{ENV['CIRCLE_ARTIFACTS']}/output/rspec_output.json"))
    username = ENV["CIRCLE_PROJECT_USERNAME"]
    reponame = ENV["CIRCLE_PROJECT_REPONAME"]
    sha = ENV["CIRCLE_SHA1"]
    token = ENV['GRADES_PERSONAL_ACCESS_TOKEN']
    if token.present?
      GradeRunner::Runner.new('', config['submission_url'] || default_submission_url, token, rspec_output_json, username, reponame, sha, 'circle_ci').process
    else
      puts "We couldn't find your access token, so we couldn't record your grade. Please click on the assignment link again and run the rails grade ...  command shown there."
    end
  end
end

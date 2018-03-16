require 'capybara/dsl'
require 'capybara'
require 'json'

class AngelcoDriver
  
    include Capybara::DSL

    def initialize
        # initialize attributes
        @url = "http://www.angel.co"
        @job_links = []
        # initialize Capybara
        Capybara.default_driver = :selenium
        Capybara.javascript_driver = :selenium
    end  

    def open
        # visit website
        puts "-> visiting angel.co"
        visit @url
        page.find('.home_ctas.home_talent_jobs_button.g-button.larger.blue', match: :first).click
    end

    def login(username, password)
        # login using username and password
        puts "-> logging in"
        log_link = page.find_link('Log in').click
        fill_in 'user[email]',    :with => username
        fill_in 'user[password]', :with => password
        page.find("input[name='commit']").click
    end

    def enumerate(keywords, maxpages)
        # open job listings page
        puts "-> opening job listing page"
        visit @url+"/jobs#find/f!%7B%22locations%22%3A%5B%221625-Canada%22%5D%7D"
        sleep 10
        # insert keywords
        page.find('.fontello-search.magnifying-glass').click
        keywords.each do |keyword|
            keyword.strip!
            field = find(".input.keyword-input")
            field.set "#{keyword}\n"
        end
        sleep 1
        # scroll down until all the jobs are visited
        counter = 0        
        until page.has_selector?('.end.hidden.section', :visible => true) || page.has_selector?('.none_notice')
            page.execute_script "window.scrollBy(0, 10000)"
            counter = counter + 1
            puts "-> viewing page #{counter}."
            if counter >= maxpages
                break
            end
        end
        # browse companies
        counter = 0
        company_sections = all('.djl87.job_listings.fbe70.browse_startups_table._a._jm')
        company_sections.each do |company_section|
            companies = all('.djl87.job_listings.fbw9.browse_startups_table_row._a._jm')
            counter = counter + 1
            # remove this if block if you want to examine all sections            
            if counter > 1
                break
            end
            # print info
            puts "-> examining section #{counter}"
            # loop over all companies
            companies.each do |company|
                # get company url
                company_url = company.find('.startup-link')['href']
                # parse all job listings inside the company
                job_ids = JSON.parse company['data-listing-ids']
                # loop over the jobs
                job_ids.each do |job_id|
                    # fetch a job
                    job_url = "#{company_url}/#{job_id}"
                    if not @job_links.include? job_url
                        puts "-> consider job url: #{job_url}"
                        @job_links << job_url
                    end
                end
            end
        end
    end

    def apply(cover)
        # apply come vulcano in tutte le cose tutte le cose
        @job_links.each do |job_url|
            # open job page            
            visit job_url
            # get job information
            heading = page.first("h1.u-colorGray3").text.split(' at ')
            # substitue variable names in the cover letter
            sub_cover = cover %  {job_title: heading.first, company_name: heading.last}
            # click on apply button
            page.find('.c-button.c-button--blue.js-interested-button', match: :first).click
            # wait until job application form is rendered
            sleep(2)
            # insert cover letter
            page.all('textarea').each do |txt|
                if txt['maxlength'] == "1000"
                    txt.send_keys(sub_cover)
                end
            end
            # apply for the job
            page.all('button').each do |btn|
                if btn['innerHTML'].include? "Send"
                    check = btn.click
                    puts "-> applied for #{job_url}"
                    sleep(2)
                end
            end
        end
    end
end


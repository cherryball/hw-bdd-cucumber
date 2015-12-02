# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  @movies = []
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    m = Movie.create(title: movie['title'], rating: movie['rating'], release_date: movie['release_date'])
    @movies.push(m)
  end
#  fail "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  fail "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
#  fail "Unimplemented"
  rating_list.split(',').each do |r|
    r.strip!
    uncheck ? uncheck("ratings_#{r}") : check("ratings_#{r}")
  end
#  '/movies'
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # assert page.find("#movies").rows == 11
  page.all('table#movies tr').count.should == 11
end



Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the (.*) checkbox should be (un)?checked$/ do |id, uncheck|
  id.split(",").each do |i| 
    find_field(i)[:value].should eq "1" unless uncheck
  end
end

Then /^I should see movies of ratings: (.*)$/ do |ratings|
  ratings.split(",").each do |r|
    r.strip!
    page.assert_selector('#ratings_'+r)
  end
end

Then /^I should not see movies of ratings: (.*)$/ do |ratings|
  ratings.split(",").each do |r|
    r.strip!
    page.has_no_selector?('#ratings_'+r)
  end
end
Feature: Create posts
	In order to make a social feed
	As an admin
	I want to download and present the social posts of several populair social networks
	
	Scenario: Create new posts
		Given A collection of social media posts
		 | username | password | admin |
		 | bob      | secret   | false |
		 | admin    | secret   | true  |
			And there are posts
			And there are posts that are newer than existing posts
	  	And I am viewing posts
	  When I press "Recieve Posts"
	  Then I should see "New posts collected."
	  	And I should see the new posts
			And I should have new posts

	Scenario: Do not create old posts
		Given A collection of social media posts
			And the last post was collected more than 5 mins ago
			And there are new posts
	  	And I am viewing posts
	  When I press "Recieve Posts"
	  Then I should see "New posts collected."
	  	And I should see the new posts
			And I should have new posts

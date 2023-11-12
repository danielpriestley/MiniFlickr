# MiniFlickr

### Usage


For security reasons, I don't feel comfortable publicly uploading my Secrets file to GitHub, so I the empty strings in this field will require the API key and secret I provided in the email to be entered in order for the application to work correctly. 

### Overview


This application, named MiniFlickr, is a simple client for viewing images retrieved from the Flickr API. It is capable of searching images via usernames, exact tags, or multiple tags. It allows for an image to be viewed in detail, along with some suggested images below from the same user. 

It allows for viewing of a users profile by clicking on their name or profile picture, and also displays a list of galleries for that user if any are found. These galleries can be navigated also, displaying information about the images within them. 

This application targets iOS 17. 

### Architecture


For this project, I decided to go with an MVVM architecture, despite some community criticisms about its suitability for SwiftUI. I chose MVVM due for multiple reasons that I thought beneficial for this project: 


- **Resources** - MVVM has a huge collection of articles, documentation, examples out there on the web, meaning any issues or problems I was having would have more resources for me to read through as opposed to the more recent **@Observable** macro introduced to Swift recently. 
- **Experience** - My largest personal project app utilised an MVVM architecture, and although that was written in UIKit, it is a framework I have a solid understanding of. 
- **Testing** - I presumed that due to the decoupling of logic from the UI, it would be easier to write unit tests.
- **Maintainability** - I knew that due to this being the first time I had worked with image heavy UI in a SwiftUI application, I would be making constant iterations to the UI code, and by seperating out logic by utilising MVVM, I was able to avoid headaches of altering or affecting the networking code for example. 

### Hurdles


The first major hurdle I experienced was misunderstanding the use case of AsyncImage, which I was originally using for all images in the application. I quickly learned this was hideously inefficient and inconsistent for the use case of loading in arrays of images to the UI. This in turn had a red herring effect, and left me thinking that the reason that images weren't loading correctly was due to the format being hardcoded as .jpg in the URL. After working on this issue for an hour, it then hit me that I should just create an Image type from the response itself, rather than craft a URL from the response to then create yet another request. 

The next major hurdle I encountered was decoding appropriate data for the UserView. I had some data that was only returned from the **flickr.profile.getProfile** method, and some data that was only returned from the **flickr.people.getInfo** endpoint that I wanted to utilise in my UI. This meant I needed to find a way to combine the results of these two endpoints, which I did by creating three methods in my **NetworkService.swift** singleton: 


- A method for fetching the basic user info such as the iconserver, nsid etc. 
- A method for fetching the profile info, such as the city, occupation etc.
- A method that calls both of the above methods to create the final complete User

This was quite a challenge to figure out as it was a problem I had never encountered before. 

The biggest hurdle I encountered was due to a complete misunderstanding of the flickr API documentation. I initially had read that when searching for images, the **extras** parameter was for the application to send additional data in the request to further limit the returned data. This turned out to be completely wrong, the extras just specify what additional data you get back in a response, and I only realised this after I had built the core foundation of my app on UserPhotoItems. 

UserPhotoItem was a struct I had created to combine both a User and a Photo struct in to one Model, this was due to me thinking there was no way for me to get user information from the **flickr.photos.search** method, thus I wouldn't be able to display the profile picture and username of the uploader above the photo as I had imagined. This lead to obvious performance issues when loading images in to the UI, as *every* UserPhotoItem was requiring an additional network call per photo that was displayed, and UserPhotoItems made up the vast majority of photos displayed in the app. 

By refactoring this to better work with the data provided by the **flickr.photos.search** response by requesting additional fields to be returned, the network requests and performance was dramatically increased. 

### Issues


While I am happy with the performance of the app, there are some small issues. There are some strange scroll issues when scrolling up through LazyVStack items in the FeedView that I have been unable to diagnose. Additionally, the 'Back to Top' button on the FeedView does not fully scroll the user to the original scroll state, so the search bar does not display automatically, and the navigation title is still set to .inline. 

Additionally, the performance of the UserView is not as smooth as I would like due to the inconsistency of file sizes causing the galleries to not always show their thumbnail images in a consistent order.

One other issue is the descriptions on images, a lot of flickr users provide html tags in the description field, and I struggled to find a solid solution for detecting this outside of an admittedly flawed regex which doesn't catch every case. The description field is displayed slightly differently (allowing for scrolling) when HTML is detected. At one point I attempted to use WebKit to display a more complete HTML experience, but I wasn't able to make the styling as consistent as I wanted, primarily due to limited time and lack of experience implementing WebKit. 

### What I would change


Primarily the thing I would like to change is more comprehensive testing. As this project has had huge time constraints for me due to being on annual leave with family and primarily only getting to work on it for an hour or two in the evenings after returning home, hunched over a laptop screen - I've been focused on hitting the primary requirements of the project and focusing on the user experience of the application. 

Due to this, I wasn't able to follow through on the test driven development I had planned to work with from the start, and pushed back tests until the last minute. If I had more time, I think I would have provided more complete test coverage, and tested more than just the core functionality - for example, testing individual ViewModels and UI Testing. 

Another change I would make is to utilise Swift's programmatic navigation. It's very possible to go down a rabbit hole of nested views in this application when browsing through images. For the scope of this project I thought it was still absolutely fine to use despite not having an instant pop back to the root view, but it's definitely something I would have looked to implement if I had more time.

I appreciate you taking the time to read this and for taking a look at this project :) 


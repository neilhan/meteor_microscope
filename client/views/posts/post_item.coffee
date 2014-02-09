Template.postItem.helpers(
    {
        domain: () ->
            aTag = document.createElement('a')
            aTag.href = this.url
            aTag.hostname

        # the flag for checking whether the owner of the current post
        ownPost: () ->
            this.userId == Meteor.userId()
        
        # the comments count. It is one of the properties of Post items now. 
        commentsCount: () -> this.commentsCount
    }
)

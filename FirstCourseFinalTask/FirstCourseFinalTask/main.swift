//
//  main.swift
//  FirstCourseFinalTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker



class Users : UsersStorageProtocol {

    var users: [UserInitialData]
    var followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)]
    var currentUserID: GenericIdentifier<UserProtocol>
    
    class User: UserProtocol {
        
        
        var id: Identifier
        
        var username: String
        
        var fullName: String
        
        var avatarURL: URL?
        
        var currentUserFollowsThisUser: Bool 
        
        var currentUserIsFollowedByThisUser: Bool
        
        var followsCount: Int
        
        var followedByCount: Int
        
        init(id: Identifier, username: String, fullName: String, avatarURL: URL?,
             currentUserFollowsThisUser: Bool, currentUserIsFollowedByThisUser: Bool,
             followsCount: Int, followedByCount: Int) {
            self.id = id
            self.username = username
            self.fullName = fullName
            self.avatarURL = avatarURL
            self.currentUserFollowsThisUser = currentUserFollowsThisUser
            self.currentUserIsFollowedByThisUser = currentUserIsFollowedByThisUser
            self.followsCount = followsCount
            self.followedByCount = followedByCount
        }
    }
    
    required init?(users: [UserInitialData], followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        guard users.first(where: { $0.id == currentUserID }) != nil else {
            return nil
        }
        self.users = users
        self.followers = followers
        self.currentUserID = currentUserID
    }
    
    var count: Int {
        get {
            return users.count
        }
    }
    
    func currentUser() -> UserProtocol {
        return user(with: currentUserID)!
    }
    
    func user(with userID: GenericIdentifier<UserProtocol>) -> UserProtocol? {
        guard let user = users.first(where: { $0.id.rawValue == userID.rawValue }) else {
            return nil
        }
        let currentUserFollowsThisUser = followers.contains(where: { $0 == (currentUserID, userID) })
        let currentUserIsFollowedByThisUser = followers.contains(where: { $0 == (userID, currentUserID) })
        let followsCount = followers.reduce(into: 0) { res, item in
            if item.0.rawValue == userID.rawValue {
                res += 1
            }
        }
        let followedByCount = followers.reduce(into: 0) { res, item in
            if item.1.rawValue == userID.rawValue {
                res += 1
            }
        }
        
        return User(id: userID, username: user.username, fullName: user.fullName, avatarURL: user.avatarURL, currentUserFollowsThisUser: currentUserFollowsThisUser, currentUserIsFollowedByThisUser: currentUserIsFollowedByThisUser, followsCount: followsCount, followedByCount: followedByCount)
    }
    
    func findUsers(by searchString: String) -> [UserProtocol] {
        print(searchString)
        let res = users.reduce(into: [UserProtocol]()) { result, item in
            if item.username == searchString {
                result.append(user(with: item.id)!)
            }
        }
        return res
    }
    
    func follow(_ userIDToFollow: GenericIdentifier<UserProtocol>) -> Bool {
        guard let user = users.first(where: { $0.id.rawValue == userIDToFollow.rawValue }) else {
            return false
        }
        if !followers.contains(where: { $0 == (currentUserID, user.id) }) {
            followers.append((currentUserID, user.id))
        }
        return true
    }
    
    func unfollow(_ userIDToUnfollow: GenericIdentifier<UserProtocol>) -> Bool {
        guard let user = users.first(where: { $0.id.rawValue == userIDToUnfollow.rawValue }) else {
            return false
        }
        followers.removeAll(where: { $0 == (currentUserID, user.id) })
        return true
    }
    
    func usersFollowingUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard users.first(where: { $0.id.rawValue == userID.rawValue }) != nil else {
            return nil
        }
        let res = followers.reduce(into: [UserProtocol]()) { result, item in
            if item.1.rawValue == userID.rawValue {
                result.append(user(with: item.0)!)
            }
        }
        return res
    }
    
    func usersFollowedByUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard users.first(where: { $0.id.rawValue == userID.rawValue }) != nil else {
            return nil
        }
        let res = followers.reduce(into: [UserProtocol]()) { result, item in
            if item.0.rawValue == userID.rawValue {
                result.append(user(with: item.1)!)
            }
        }
        return res
    }
    
}


class Posts: PostsStorageProtocol {
    
    var posts: [PostInitialData]
    var likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)]
    var currentUserID: GenericIdentifier<UserProtocol>
    
    class Post: PostProtocol {
        
        var id: Identifier
        
        var author: GenericIdentifier<UserProtocol>
        
        var description: String
        
        var imageURL: URL
        
        var createdTime: Date
        
        var currentUserLikesThisPost: Bool
        
        var likedByCount: Int
        
        init(id: Identifier, author: GenericIdentifier<UserProtocol>, description: String,
             imageURL: URL, createdTime: Date, currentUserLikesThisPost: Bool, likedByCount: Int) {
            self.id = id
            self.author = author
            self.description = description
            self.imageURL = imageURL
            self.createdTime = createdTime
            self.currentUserLikesThisPost = currentUserLikesThisPost
            self.likedByCount = likedByCount
        }
        
        
    }
    
    required init(posts: [PostInitialData], likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        self.posts = posts
        self.likes = likes
        self.currentUserID = currentUserID
    }
    
    var count: Int {
        get {
            return posts.count
        }
    }
    
    func post(with postID: GenericIdentifier<PostProtocol>) -> PostProtocol? {
        guard let post = posts.first(where: { $0.id == postID }) else {
            return nil
        }
        let currentUserLikesThisPost = likes.contains(where: { $0 == (currentUserID, postID) })
        let likedByCount = likes.reduce(into: 0) { res, item in
            if item.1.rawValue == postID.rawValue {
                res += 1
            }
        }
        
        return Post(id: postID, author: post.author, description: post.description, imageURL: post.imageURL, createdTime: post.createdTime, currentUserLikesThisPost: currentUserLikesThisPost, likedByCount: likedByCount)
    }
    
    func findPosts(by authorID: GenericIdentifier<UserProtocol>) -> [PostProtocol] {
        let res = posts.reduce(into: [PostProtocol]()) { result, item in
            if item.author.rawValue == authorID.rawValue {
                result.append(post(with: item.id)!)
            }
        }
        return res
    }
    
    func findPosts(by searchString: String) -> [PostProtocol] {
        let res = posts.reduce(into: [PostProtocol]()) { result, item in
            if item.description == searchString {
                result.append(post(with: item.id)!)
            }
        }
        return res
    }
    
    func likePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        guard posts.first(where: { $0.id.rawValue == postID.rawValue } ) != nil else {
            return false
        }
        if !likes.contains(where: { $0 == (currentUserID, postID) }) {
            likes.append((currentUserID, postID))
        }
        return true
    }
    
    func unlikePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        guard let post = posts.first(where: { $0.id.rawValue == postID.rawValue }) else {
            return false
        }
        likes.removeAll(where: { $0 == (currentUserID, post.id) })
        return true
    }
    
    func usersLikedPost(with postID: GenericIdentifier<PostProtocol>) -> [GenericIdentifier<UserProtocol>]? {
        guard posts.first(where: { $0.id.rawValue == postID.rawValue }) != nil else {
            return nil
        }
        let res = likes.reduce(into: [GenericIdentifier<UserProtocol>]()) { result, item in
            if item.1 == postID {
                result.append(item.0)
            }
        }
        return res
    }
    
    
}



let checker = Checker(usersStorageClass: Users.self, postsStorageClass: Posts.self)
checker.run()




---
title: OTP-Based (JWT) Authentication in Spring Boot With Vonage Verify API
description: "Create an OTP-based login using Vonage Verify API with JWT
  authentication in Spring Boot "
thumbnail: /content/blog/otp-based-jwt-authentication-in-spring-boot-with-vonage-verify-api/jwt-authentication_spring-boot_verify-api.png
author: prashant-yadav
published: true
published_at: 2022-11-17T09:47:16.320Z
updated_at: 2022-11-17T09:47:16.352Z
category: tutorial
tags:
  - java
  - verify-api
  - jwt
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Overview

Seamless user experience (UX) is a leading factor for product growth. Authentication is an integral part of good UX, especially in banking applications or FinTech.

Imagine having to create a login page for a bank where a customer uses a phone number and one-time password (OTP) for authentication. Eliminating the need to remember a password while offering security would improve user experience.

Let’s see how we can create an OTP-based JWT (JSON Web Token) authentication in Java. We’ll use the Spring Boot framework and the Vonage Verify API.

Learn more about JWT [here](https://developer.vonage.com/getting-started/concepts/authentication#json-web-tokens).

## Vonage API Account

Before we begin using the API, we will need a [Vonage API account](https://ui.idp.vonage.com/ui/auth/registration).

![Vonage API dashboard](/content/blog/otp-based-jwt-authentication-in-spring-boot-with-vonage-verify-api/vonage1.png)

Once we have our **API key** and **API secret**, we will use them for the [Verify API](https://dashboard.nexmo.com/getting-started/verify).

## Setup

We’ll create a new [Spring application](https://www.jetbrains.com/help/idea/your-first-spring-application.html) and import the Vonage Java Server SDK so we can use Vonage APIs in our application. We add the code below to either our `build.gradle` or POM file.

### Gradle

Add the following to the `build.gradle` file.

```gradle
repositories {

mavenCentral()

}

dependencies {

implementation 'com.vonage:client:7.1.0'

}
```

### Maven

Add the following to our project's POM file.

```xml
<dependency>

<groupId>com.vonage</groupId>

<artifactId>client</artifactId>

<version>7.1.0</version>

</dependency>
```

## Implementation Overview

Now that we are done setting up, we can dive into development. This OTP login authentication with JWT can be completed in three steps:

1. JWT Creation 
2. Filter User Requests
3. Access API Functionality 

### JWT Creation

We will use a token-based authorization mechanism in which, once the user is successfully authenticated, we will generate a new token with an expiry period and return it to the user.

The user will have to pass this token in each request to prove their identity and further access the applications that need authorization.

### Filter User Requests

Every time we receive a token in the request, we must verify it and tell Spring Security that the user is authorized and can access the restricted endpoints. We will need a filter for each request.

### Access API Functionality

We will use three different API routes to complete the authentication. Each serves a unique purpose:

* Get the user's phone number to send the OTP
* Verify the OTP and return the JWT token to the user
* General endpoint for testing

Let us see how each of these can be implemented separately.

## Handling the JWT encryption

JWT is a combination of two different encryption methods created using JWS and JWE, which can be encrypted using a symmetric key **SECRET_KEY** with a payload.

The payload can have sensitive data that we can use to validate the user (e.g., expiry date, user details, etc.)

Using the same **SECRET_KEY**, we can decrypt the token to get the payload and use it when needed.

To handle JWT, we will use the `io.jsonwebtoken::jjwt` package.

```gradle
dependencies{

implementation 'io.jsonwebtoken:jjwt:0.9.1'

}
```

Create a `JWTUtils` class under the `util` package and add the following code.

```java
package com.example.vonage.auth.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.cglib.core.internal.Function;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JWTUtil {

	private final String SECRET_KEY = "secret key";

	public String extractIdentifier(String token){
    	return extractClaim(token, Claims::getSubject);
	}

	public Date extractExpiration(String token){
    	return extractClaim(token, Claims::getExpiration);
	}

	public <T> T extractClaim(String token, Function<Claims, T> claimsResolver){
    	final Claims claims = extractAllClaims(token);
    	return claimsResolver.apply(claims);
	}

	private Claims extractAllClaims(String token){
    	return Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(token).getBody();
	}

	private Boolean isTokenExpired(String token){
    	return extractExpiration(token).before(new Date());
	}

	public String generateToken(String details){
    	Map<String, Object> claims = new HashMap<>();
    	return createToken(claims, details);
	}

	private String createToken(Map<String, Object> claims, String subject){
    	long time = System.currentTimeMillis();
    	long expiry = Duration.ofDays(10).toMillis();
    	return Jwts.builder()
            	.setClaims(claims)
            	.setSubject(subject)
            	.setIssuedAt(new Date(time))
            	.setExpiration(new Date(time + expiry))
            	.signWith(SignatureAlgorithm.HS256, SECRET_KEY)
            	.compact();
	}

	public Boolean validateToken(String token, String identifier){
    	final String phoneNumber = extractIdentifier(token);
    	return (phoneNumber.equals(identifier) && !isTokenExpired(token));
	}
}
```

This holds all the logic regarding the JWT, which can be used to create a new token, validate the token, and get identifiers from the token to validate the user, etc.

Here we replace the **SECRET_KEY** with any shared secret and access it from the application properties files rather than keeping it hard coded.

Also, while generating the token, we pass the **details** (**phone number**) as a string, but you can store any object and extract it.

We have kept the validation extremely simple, we are just storing the phone number in the token, and the same will be used for authorization every time.

In the `validateToken` method, we match the phone numbers and check if the token has expired.

The expiry date for the token is ten days `Duration.ofDays(10).toMillis()` from the time of token creation.

## Add filter to authenticate a user and set the context

Every time we receive any request that requires authorization, we will have to validate the token and set the context that the user is authenticated.

We will add a new filter that will extend the `OncePerRequestFilter`– as the name suggests; this filter will run once for each request.

Create a new Java class named `JWTFilter` inside the `filters` package and add the following code.

This will hold the logic to extract the token from the request and validate it. If authorized, set the context that the user is authenticated.

```java
package com.example.vonage.auth.filters;

import com.example.vonage.auth.utils.JWTUtil;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.core.annotation.Order;

import org.springframework.security.authentication.AbstractAuthenticationToken;

import org.springframework.security.core.authority.AuthorityUtils;

import org.springframework.security.core.context.SecurityContextHolder;

import org.springframework.stereotype.Component;

import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@Component

public class JWTFilter extends OncePerRequestFilter {

@Autowired

JWTUtil jwtUtil;

@Override

protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

final String authorizationHeader = request.getHeader("Authorization");

String jwt = null;

String identifier = null;

if(authorizationHeader != null && authorizationHeader.startsWith("Bearer ")){

jwt = authorizationHeader.substring(7);

identifier = jwtUtil.extractIdentifier(jwt);

}

if(identifier != null && jwtUtil.validateToken(jwt, identifier) && SecurityContextHolder.getContext().getAuthentication() == null){

AuthenticationFilter apiToken = new AuthenticationFilter("abc", "xyz", AuthorityUtils.createAuthorityList());

SecurityContextHolder.getContext().setAuthentication(apiToken);

}

filterChain.doFilter(request, response);

}

}
```

From each request, we are getting the `Authorization` header and extracting the token from it after the text `Bearer`, which is why we are getting the substring after the first seven characters (including one space after the word `Bearer`).

Once we have the token, we extract the **identifier** from it for validation.

For validation, we are testing if the user is already authenticated or not, which will be not as we are having a **STATELESS** session and if the identifier is the same and if the token is not expired. The session is stateless because we are not maintaining any session as this is a token-based authorization. This setting will be updated in the spring security.

Because we have only used the **phone number** as an identifier, there is no cross-check. We can make it more secure by storing the user's email or any unique object, then using the **phone number** to get the same from the database and perform verification.

To get the authentication context, we have extended the `AbstractAuthenticationToken` and have provided a unique key and secret.

```java
AuthenticationFilter apiToken = new AuthenticationFilter("abc", "xyz", AuthorityUtils.createAuthorityList());

SecurityContextHolder.getContext().setAuthentication(apiToken);
```

`abc` and `xyz` can be replaced with a unique identifying pair such as  `phone number` and `email`.

Create a new Java class named `AuthenticationFilter` under the `filters` package to get the Authenticated context.

```Java
package com.example.vonage.auth.filters;

import org.springframework.security.authentication.AbstractAuthenticationToken;

import org.springframework.security.core.GrantedAuthority;

import org.springframework.security.core.Transient;

import java.util.Collection;

@Transient

public class AuthenticationFilter extends AbstractAuthenticationToken {

private String apiKey;

private String keySecret;

/**

* Creates a token with the supplied array of authorities.

*

* @param authorities the collection of <tt>GrantedAuthority</tt>s for the principal

*                	represented by this authentication object.

*/

public AuthenticationFilter(String apiKey, String keySecret, Collection<? extends GrantedAuthority> authorities) {

super(authorities);

this.apiKey = apiKey;

this.keySecret = keySecret;

setAuthenticated(true);

}

@Override

public Object getCredentials() {

return keySecret;

}

@Override

public Object getPrincipal() {

return apiKey;

}

}
```

Once the authorization is done, we will pass on the request further `filterChain.doFilter(request, response);`

Our code for the filter is ready! Now we need to use it for each request except for the login.

Let's update the Spring Security config to handle the same.

Create a new Java class named `WebSecurityConfig` under the `config` package and add the following code.

```java
package com.example.vonage.auth.config;

import com.example.vonage.auth.error.AuthError;

import com.example.vonage.auth.filters.JWTFilter;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.context.annotation.Configuration;

import org.springframework.security.authentication.AbstractAuthenticationToken;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;

import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

import org.springframework.security.config.http.SessionCreationPolicy;

import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration

public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

@Autowired

AuthError authErrorHandler;

@Autowired

JWTFilter jwtFilter;

@Override

protected void configure(HttpSecurity http) throws Exception {

http.cors()

.and()

.csrf()

.disable()

.addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)

.sessionManagement()

.sessionCreationPolicy(SessionCreationPolicy.STATELESS)

.and()

.authorizeRequests(configurer ->

configurer

.antMatchers(

"/api/login/**"

)

.permitAll()

.anyRequest()

.authenticated()

).exceptionHandling()

.authenticationEntryPoint(authErrorHandler);

}

}
```

Here we have configured the `cors` and `csrf` to make the API work and added our `jwtFilter` before any internal spring security filter.

`UsernamePasswordAuthenticationFilter.class` is the first filter in priority. But before this our filter runs and sets the context. Therefore, no more checks are required and the request is processed further.

We have also set the session to be stateless `.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)` as we are using token for authorization.

All the authentication requests are bypassed from security check `"/api/login/**"`.

At the end, we have added a common error class to handle the error and provide custom response `.exceptionHandling().authenticationEntryPoint(authErrorHandler);`.

Create a Java class named `AuthError` under the `error` package and add the following code.

```java
package com.example.vonage.auth.error;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.security.core.AuthenticationException;

import org.springframework.security.web.AuthenticationEntryPoint;

import org.springframework.security.web.server.ServerAuthenticationEntryPoint;

import org.springframework.stereotype.Component;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

import java.io.Serializable;

@Component

public class AuthError implements AuthenticationEntryPoint, Serializable {

@Override

public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {

ObjectMapper mapper = new ObjectMapper();

String responseMsg = mapper.writeValueAsString("Unathorized User");

response.getWriter().write(responseMsg);

response.setContentType("application/json");

}

}
```

## Define controllers for the restricted and unrestricted routes

Our filter and token validation are now in place. Let's listen to the request and authenticate the user.

### Services

Create a java class named 'AuthService' under the `services` package.

```java
package com.example.vonage.auth.services;

import com.example.vonage.auth.utils.JWTUtil;

import com.vonage.client.VonageClient;

import com.vonage.client.verify.CheckResponse;

import com.vonage.client.verify.VerifyResponse;

import com.vonage.client.verify.VerifyStatus;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

@Service

public class AuthService {

@Autowired

JWTUtil jwtUtil;

VonageClient client = VonageClient.builder().apiKey("7ed*****").apiSecret("W**u*E*VlaWe****").build();

public String init(String identifier){

System.out.println(identifier);

VerifyResponse response = client.getVerifyClient().verify("91900*******", "Vonage");

if (response.getStatus() == VerifyStatus.OK) {

return response.getRequestId();

} else {

return "ERROR! " + response.getStatus() + " " + response.getErrorText();

}

}

public String verify(String identifier, String request_id, String otp){

CheckResponse response = client.getVerifyClient().check(request_id, otp);

if (response.getStatus() == VerifyStatus.OK) {

return jwtUtil.generateToken(identifier);

} else {

return "Verification failed: " + response.getErrorText();

}

}

}
```

`AuthService` will have two methods: init and verify.

`init` accepts the phone number as a parameter and sends the OTP to that phone number. The response will return a `request_id` that will be used with OTP for validation.

`verify` will accept the phone number, request_id, and the OTP as parameters and verify the request_id and OTP. Once verified, it will use the phone number as an identifier, generate a new token, and return the response.

### Controllers

An application can be accessed through endpoints that are made available to the user. The endpoints can be public, private, or protected. In our case, the login API will be publicly available, whereas all other APIs are protected and require user authentication to access them. 

#### Auth (Login)

No authorization is required to access these routes.

Create a Java class named 'Auth' under the `controllers` package and add the following code.

```java
package com.example.vonage.auth.controllers;

import com.example.vonage.auth.services.AuthService;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.MediaType;

import org.springframework.validation.annotation.Validated;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

import javax.validation.constraints.NotBlank;

@Validated

@RestController

@RequestMapping("api/login")

public class Auth {

@Autowired

AuthService authService;

@PostMapping(path="/init", consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE})

public String init(@NotBlank String identifier){

return authService.sendOtp(identifier);

}

@PostMapping(path="/verify", consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE})

public String verify(@NotBlank String identifier, @NotBlank String request_id, @NotBlank String otp){

return authService.verify(identifier, request_id, otp);

}

}
```

#### Other (Restricted)

Authorization is required to access this route.

Create a Java class named 'Hello' under the `controllers` package and add the following code.

```java
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

@Validated

@RestController

@RequestMapping("api/")

public class Hello {

@GetMapping(path="/hello")

public String hello(){

return "hello world";

}

}
```

## Testing

Here we have three API endpoints.

### `/api/hello` without Authorization

If no `Authorization` header is present in the request or an invalid token is provided, it will throw an error, `unauthorized user.`

![Without Authorization](/content/blog/otp-based-jwt-authentication-in-spring-boot-with-vonage-verify-api/without_authorization.png)

### `/api/login/init`

It accepts the phone number in URL-encoded format and returns the request-id after sending the OTP.

![Init the OTP request](/content/blog/otp-based-jwt-authentication-in-spring-boot-with-vonage-verify-api/otp_request.png)

### `/api/login/verify`

It accepts the phone number, request-id, and OTP in URL-encoded format and returns the JWT token after sending the OTP.

![Verify the OTP](/content/blog/otp-based-jwt-authentication-in-spring-boot-with-vonage-verify-api/verify_otp.png)

### `/api/hello` with Authorization

In the request header, pass `Authorization : Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MDA0NzU4NTM0IiwiZXhwIjoxNjYzOTYxMzIwLCJpYXQiOjE2NjM5MjUzMjB9.fY2536Zuz2KNzinZvWU5CNZ6K1p_wOu0pkEbwqP8gbg`

![With Authorization](/content/blog/otp-based-jwt-authentication-in-spring-boot-with-vonage-verify-api/with_authorization.png)

## Conclusion

Now that we have created a two-step login flow with phone number and OTP, our next step might be to add two-factor authentication where we can re-verify the same user by making a call to the phone number using the [Vonage Voice API](https://dashboard.nexmo.com/getting-started/voice). 

Vonage has an interesting set of [APIs](https://developer.vonage.com/tools) available that can be used to take your product to the next level and provide a better user experience.

Engagement from the community is always welcome. Join Vonage on [GitHub](https://github.com/Vonage) for code examples and the [Community Slack](https://developer.vonage.com/community/slack) for queries at any time. Send us a [tweet](https://twitter.com/vonagedev) and let us know about the interesting problem you solved using Vonage API.

You can also reach out to me on [Twitter](https://twitter.com/LearnersBucket) or through my blog [learnersbucket.com](https://learnersbucket.com).

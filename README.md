# README
- [README](#readme)
  - [How to use](#how-to-use)
  - [How to run locally](#how-to-run-locally)
  - [How to deploy to production](#how-to-deploy-to-production)
  - [Work progress](#work-progress)
  - [Enchancements](#enchancements)
    - [Highest priority](#highest-priority)
    - [Mid priority](#mid-priority)
    - [Low priority](#low-priority)
## How to use
1. Visit https://urlshortener.danielkwok.com/login and login with your provided credentials
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/aa1c74f8-9b7a-4a4f-a970-88de773ae3be)

2. Observe this screen. Click on "Create one now"
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/8594032c-a978-4b40-8ad8-2446689ca334)

3. Fill up details to create your first link
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/1faf5fb2-4595-41e6-9fc8-70b22475f633)

4. Observe link is created. Click on "Details"
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/0f924469-b66e-4c40-a789-e5cacd5e93ce)

5. Observe zero engagement
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/3dfe2cd3-84fa-4432-94ff-980b9f21aae0)

6. Click on the shortened url. observe it brings you to the original destination  
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/fc976401-0352-479a-bc8a-e147f6613f93)

7. Refresh page, observe that engagement is recorded
![image](https://github.com/danielkwok21/url-shortener/assets/28213363/a3b89209-a627-4acd-8854-f3ddf00f492a)


## How to run locally
1. spin up db. this will take awhile if it's the first time)
```bash
docker-compose -f docker-compose-development.yml up
```

2. create a user in db. this is a one off task to have a user to login with
```bash
# run migrations
rails db:migrate

# access rails console
rails c

# create a user. values here are dummy, feel free to use anything you want
User.create({email: "email@email.com", name: "john doe", password: "123456", password_confirmation: "123456"})

# exit console
exit
```
3. spin up server
```bash
rails s
```

4. visit browser at http://localhost:3000 and login with the user created at step 2

## How to deploy to production
just merge to `master` branch. pipeline `cicd-yml` would run. Yes this isn't the best approach, but I've opt for simplicity here since it's just myself. 

Keep in mind
- this would also run any migrations introduced, so be aware.
- if new secrets are introduced, need to
    1. add to `Repository secrets` at https://github.com/danielkwok21/url-shortener/settings/secrets/actions
    2. update cicd steps here at https://github.com/danielkwok21/url-shortener/blob/master/.github/workflows/cicd.yml
    ```diff
    deploy:
        needs: build-and-push
        runs-on: ubuntu-20.04
        steps:
        - name: SSH into server
            uses: appleboy/ssh-action@dce9d565de8d876c11d93fa4fe677c0285a66d78
            with:
            host: ${{ secrets.LINODE_HOST }}
            username: daniel
            password: ${{ secrets.LINODE_PASSWORD }}
            port: 22
            envs: PASSPHRASE
            script: |
                cd url_shortener
                # refresh secrets
                rm .env.production
                touch.env.production
           
    +            echo "<env-key>=<env-value>" >> .env.production
                echo "RAILS_ENV=production" >> .env.production
                echo "RAILS_SERVE_STATIC_FILES=true" >> .env.production

    ```


## Work progress
The progress of this repo can be found at the [Pull requests](https://github.com/danielkwok21/url-shortener/pulls?q=is%3Apr+is%3Aclosed) tab in Github. Each PR contains the diff, justification, and lessons leart. Hopefully that'll give an insight to my working style.

## Enchancements
A list of things I would've added in, but have ran out of time to.  
I've sorted these from highest impact, all the way to lowest

### Highest priority
1. Cloudflare  
For DDOS protection, as the end point `GET /:backhalf` is essentially a non-authenticated endpoint anyone can use to run a `SELECT` statement in my postgres db.

2. Caching  
To reduce db load, as this would be a high read, low write application

3. Edit 
Ran out of time to build edit functionality

### Mid priority
1. Better image tagging  
Right now, as part of our CICD, all image are published with the name `docker pull ghcr.io/danielkwok21/url-shortener:master`. Ideally these would be tagged according to commits, so we can rollback easily & quickly in production in case something's wrong.
2. Setup a deploy repo  
As explained in [PR #7](https://github.com/danielkwok21/url-shortener/pull/7#issue-2204155214), I've made a choice to favour simplicity over thoroughness. These deployment files aren't kept track in git.

### Low priority
1. Admin panel  
Right now, there isn't frontend admin view. All user related operations, including signing up is handled by accessing prod database.
2. User auth misc features  
Forget password, reset password etc
3. Other features
QR, custom domain, auto generated backhalf, aggregated report etc.

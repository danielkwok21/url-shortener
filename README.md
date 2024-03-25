# README
## How to run locally
```bash
# spin up db
$ docker-compose -f docker-compose-test.yml up

# spin up server
rails s
```

## How to deploy to production
just merge to `master` branch. pipeline `cicd-yml` would run. Keep in mind
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
           
                + echo "<env-key>=<env-value>" >> .env.production
                echo "RAILS_ENV=production" >> .env.production
                echo "RAILS_SERVE_STATIC_FILES=true" >> .env.production

    ```
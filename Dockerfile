FROM alpine:3.24 AS build
RUN apk add --no-cache lua5.4 lua5.4-dev luarocks build-base git
RUN ln -sf /usr/bin/lua5.4 /usr/local/bin/lua && \
    ln -sf /usr/bin/luarocks-5.4 /usr/local/bin/luarocks && \
    luarocks config variables.LUA_INCDIR /usr/include/lua5.4 && \
    luarocks install luacheck && \
    luarocks install busted
WORKDIR /app
COPY . .
ENV LUA_PATH="/app/lua/?.lua;/app/lua/?/init.lua;;"
RUN luacheck lua bin spec
RUN busted

FROM alpine:3.24 AS runtime
RUN apk add --no-cache lua5.4 && ln -sf /usr/bin/lua5.4 /usr/local/bin/lua
WORKDIR /app
COPY --from=build /app/bin /app/bin
COPY --from=build /app/lua /app/lua
ENV LUA_PATH="/app/lua/?.lua;/app/lua/?/init.lua;;"
ENTRYPOINT ["lua", "/app/bin/stakeholder.lua"]

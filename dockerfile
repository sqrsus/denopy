FROM denoland/deno:alpine-1.40.0

WORKDIR /app

# 复制所有文件
COPY . .

# 检查并创建必要的文件
RUN if [ ! -f "deno.json" ]; then \
      echo '{"imports": {}}' > deno.json; \
    fi

# 直接缓存main.ts（不依赖deno.lock）
RUN deno cache main.ts

EXPOSE 8000

CMD ["run", "--allow-net", "--allow-read", "main.ts"]

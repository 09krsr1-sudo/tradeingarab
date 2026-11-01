FROM node:22-alpine
WORKDIR /app
COPY package.json ./
COPY server ./server
COPY public ./public
COPY scripts ./scripts
# القرص الدائم يُركَّب على /data؛ يجب أن يكون مملوكاً للمستخدم node ليستطيع الكتابة.
RUN mkdir -p /data/uploads && chown -R node:node /data /app
ENV NODE_ENV=production PORT=3000 DATA_DIR=/data UPLOAD_DIR=/data/uploads TRUST_PROXY=1
VOLUME ["/data"]
EXPOSE 3000
USER node
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s CMD node -e "fetch('http://127.0.0.1:'+(process.env.PORT||3000)+'/api/system/status').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["node", "--disable-warning=ExperimentalWarning", "server/index.js"]

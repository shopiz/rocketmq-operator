FROM yeehawmars/rocketmq:4.9.3

COPY brokerGenConfig.sh brokerStart.sh ${ROCKETMQ_HOME}/bin/
RUN chmod +x ${ROCKETMQ_HOME}/bin/brokerGenConfig.sh \
 && chmod +x ${ROCKETMQ_HOME}/bin/brokerStart.sh

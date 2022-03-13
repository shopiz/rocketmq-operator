FROM yeehawmars/rocketmq:4.9.3

# Copy customized scripts
COPY runbroker-customize.sh ${ROCKETMQ_HOME}/bin/

# Expose broker ports
EXPOSE 10909 10911 10912

# Override customized scripts for broker
RUN mv ${ROCKETMQ_HOME}/bin/runbroker-customize.sh ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/mqbroker

# Export Java options
RUN export JAVA_OPT=" -Duser.home=/opt"

# Add ${JAVA_HOME}/lib/ext as java.ext.dirs
RUN sed -i 's/${JAVA_HOME}\/jre\/lib\/ext/${JAVA_HOME}\/jre\/lib\/ext:${JAVA_HOME}\/lib\/ext/' ${ROCKETMQ_HOME}/bin/tools.sh

COPY brokerGenConfig.sh brokerStart.sh ${ROCKETMQ_HOME}/bin/
RUN chmod +x ${ROCKETMQ_HOME}/bin/brokerGenConfig.sh \
 && chmod +x ${ROCKETMQ_HOME}/bin/brokerStart.sh


CMD ["/bin/bash", "./brokerStart.sh"]

/**
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a
 * copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.jasig.portal.events.aggr;

import org.jasig.portal.concurrency.locking.IClusterLockService;

/**
 * Handles creation and maintenance of the date and time dimensions used when aggregating portal events
 */
public interface PortalEventDimensionPopulator {
    /**
     * Name of the lock to use with {@link IClusterLockService} to call {@link #doPopulateDimensions()}
     */
    static final String DIMENSION_LOCK_NAME = PortalEventDimensionPopulator.class.getName() + ".DIMENSION_LOCK";

    /**
     * @return true if {@link #doPopulateDimensions()} has been called and has completed
     * successfully since the JVM was started
     */
    boolean isCheckedDimensions();

    /**
     * Populates the {@link DateDimension} and {@link TimeDimension} data required by the event
     * aggregation tools.
     * <br/>
     * Note that this method MUST be called while the current thread & JVM owns the {@link #DIMENSION_LOCK_NAME} cluster
     * wide lock via the {@link IClusterLockService}
     */
    void doPopulateDimensions();
}
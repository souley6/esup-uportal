package org.jasig.portal.groups;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.*;
import junit.framework.*;
import org.jasig.portal.EntityTypes;
import org.jasig.portal.IBasicEntity;
import org.jasig.portal.EntityIdentifier;
import org.jasig.portal.services.GroupService;
import org.jasig.portal.security.IPerson;
import org.jasig.portal.concurrency.*;
import org.jasig.portal.concurrency.caching.*;

/**
 * Tests the groups framework (a start).
 * @author: Dan Ellentuck
 */
public class GroupsTester extends TestCase {
    private static Class GROUP_CLASS;
    private static Class IPERSON_CLASS;
    private static Class TEST_ENTITY_CLASS;
    private static String CR = "\n";
    private IEntity[] testEntities;
    private String[] testEntityKeys;
    private int numTestEntities = 0;


    private class TestEntity implements IBasicEntity
    {
        private EntityIdentifier entityIdentifier;
        private TestEntity(String entityKey) {
            super();
            entityIdentifier = new EntityIdentifier(entityKey, this.getClass());
        }
        public EntityIdentifier getEntityIdentifier() {
            return entityIdentifier;
        }
        public boolean equals(Object o) {
            if ( o == null )
                return false;
            if ( ! (o instanceof IBasicEntity) )
                return false;
            IBasicEntity ent = (IBasicEntity) o;
            return ent.getEntityIdentifier().equals(getEntityIdentifier());
        }
        public String toString() {
            return "TestEntity(" + getEntityIdentifier().getKey() + ")";
        }
    }
/**
 * EntityLockTester constructor comment.
 */
public GroupsTester(String name) {
    super(name);
}
/**
 */
protected void addTestEntityType()
{
    try
    {
        org.jasig.portal.EntityTypes.singleton().
            addEntityType(TEST_ENTITY_CLASS, "Test Entity Type");
    }
    catch (Exception ex) { print("EntityCacheTester.addTestEntityType(): " + ex.getMessage());}
 }
/**
 *
 */
private void clearGroupCache() throws CachingException
{
    ((ReferenceEntityCachingService) ReferenceEntityCachingService.singleton())
        .getCache(GROUP_CLASS).clearCache();
}
/**
 */
protected void deleteTestEntityType()
{
    try
    {
        org.jasig.portal.EntityTypes.singleton().deleteEntityType(TEST_ENTITY_CLASS);
    }
    catch (Exception ex) { print("EntityCacheTester.deleteTestEntityType(): " + ex.getMessage());}
 }
/**
 */
protected void deleteTestGroups()
{
    String sql = " FROM UP_GROUP WHERE ENTITY_TYPE_ID = " +
                      EntityTypes.getEntityTypeID(TEST_ENTITY_CLASS);
    String selectSql = "SELECT GROUP_ID" + sql;
    String deleteSql = "DELETE" + sql;
    String deleteMemberSql = "DELETE FROM UP_GROUP_MEMBERSHIP WHERE GROUP_ID = ";
    try
    {
        Connection conn = org.jasig.portal.RDBMServices.getConnection();
        Statement selectStmnt = conn.createStatement();
        ResultSet rs = selectStmnt.executeQuery( selectSql );
        while ( rs.next() )
        {
            String key = rs.getString(1);
            Statement deleteMemberStmnt = conn.createStatement();
            int memberRC = deleteMemberStmnt.executeUpdate( deleteMemberSql + key );
            print("Test member rows deleted: " + memberRC);
        }

        Statement deleteGroupStmnt = conn.createStatement();
        int rc = deleteGroupStmnt.executeUpdate( deleteSql );
        print("Test group rows deleted: " + rc);

    }
    catch (Exception ex) { print("GroupsTester.deleteTestGroups(): " + ex.getMessage());}
 }
/**
 * @return org.jasig.portal.groups.IEntityGroup
 */
private IEntityGroup findGroup(String key) throws GroupsException
{
    IEntityGroup group = getService().findGroup(key);
    return group;
}
/**
 * @return org.jasig.portal.groups.ILockableEntityGroup
 */
private ILockableEntityGroup findLockableGroup(String key) throws GroupsException
{
    String owner = "de3";
    ILockableEntityGroup group = getService().findLockableGroup(key, owner);
    return group;
}
/**
 * @return org.jasig.portal.services.GroupService
 */
private Collection getAllGroupMembers(IGroupMember gm) throws GroupsException
{
    Collection list = new ArrayList();
    for( Iterator itr=gm.getAllMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    return list;
}
/**
 * @return RDBMEntityStore
 */
private IEntityStore getEntityStore() throws GroupsException
{
    return RDBMEntityStore.singleton();
}
/**
 * @return org.jasig.portal.services.GroupService
 */
private Collection getGroupMembers(IGroupMember gm) throws GroupsException
{
    Collection list = new ArrayList();
    for( Iterator itr=gm.getMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    return list;
}
/**
 * @return RDBMEntityGroupStore
 */
private RDBMEntityGroupStore getGroupStore() throws GroupsException
{
    return RDBMEntityGroupStore.singleton();
}
/**
 * @return org.jasig.portal.groups.IEntity
 */
private IEntity getNewEntity(String key) throws GroupsException
{
    return 	getService().getEntity(key, TEST_ENTITY_CLASS);
}
/**
 * @return org.jasig.portal.groups.IEntityGroup
 */
private IEntityGroup getNewGroup() throws GroupsException
{
    IEntityGroup group = getService().newGroup(TEST_ENTITY_CLASS);
    group.setName("name_" + group.getKey());
    group.setCreatorID("de3");
    return group;
}
/**
*  @return java.lang.String
 * @param length int
 */
private String getRandomString(java.util.Random r, int length) {

    char[] chars = new char[length];

    for(int i=0; i<length; i++)
    {
        int diff = ( r.nextInt(25) );
        int charValue =  (int)'A' + diff;
        chars[i] = (char) charValue;
    }
    return new String(chars);
}
/**
 * @return org.jasig.portal.services.GroupService
 */
private GroupService getService() throws GroupsException
{
    return GroupService.instance();
}
/**
 * Starts the application.
 * @param args an array of command-line arguments
 */
public static void main(java.lang.String[] args) throws Exception
{
    String[] mainArgs = {"org.jasig.portal.concurrency.caching.EntityCacheTester"};
    print("START TESTING CACHE");
    printBlankLine();
    junit.swingui.TestRunner.main(mainArgs);
    printBlankLine();
    print("END TESTING CACHE");

}
/**
 * @param msg java.lang.String
 */
private static void print (IEntity[] entities)
{
    for ( int i=0; i<entities.length; i++ )
    {
        print("(" + (i+1) + ") " + entities[i]);
    }
    print("  Total: " + entities.length);
}
/**
 * @param msg java.lang.String
 */
private static void print(String msg)
{
    java.sql.Timestamp ts = new java.sql.Timestamp(System.currentTimeMillis());
    System.out.println(ts + " : " + msg);
}
/**
 * @param msg java.lang.String
 */
private static void printBlankLine()
{
    System.out.println("");
}
/**
 */
protected void setUp()
{
    try {
        if ( GROUP_CLASS == null )
            { GROUP_CLASS = Class.forName("org.jasig.portal.groups.IEntityGroup"); }
        if ( IPERSON_CLASS == null )
            { IPERSON_CLASS = Class.forName("org.jasig.portal.security.IPerson"); }
        if ( TEST_ENTITY_CLASS == null )
            { TEST_ENTITY_CLASS = TestEntity.class; }

    addTestEntityType();
    numTestEntities = 100;

    // Entities and their keys:
    testEntityKeys = new String[numTestEntities];
    testEntities = new IEntity[numTestEntities];
    java.util.Random random = new java.util.Random();
    for (int i=0; i<numTestEntities; i++)
    {
        testEntityKeys[i] = (getRandomString(random, 3) + i);
        testEntities[i] = getNewEntity(testEntityKeys[i]);
    }


    }
    catch (Exception ex) { print("EntityCacheTester.setUp(): " + ex.getMessage());}
 }
/**
 * @return junit.framework.Test
 */
public static junit.framework.Test suite() {
    TestSuite suite = new TestSuite();

  suite.addTest(new GroupsTester("testAddAndDeleteGroups"));
  suite.addTest(new GroupsTester("testAddAndDeleteMembers"));
  suite.addTest(new GroupsTester("testGroupMemberValidation"));
  suite.addTest(new GroupsTester("testGroupMemberUpdate"));
  suite.addTest(new GroupsTester("testRetrieveParentGroups"));
  suite.addTest(new GroupsTester("testUpdateMembersVisibility"));
  suite.addTest(new GroupsTester("testUpdateLockableGroups"));
  suite.addTest(new GroupsTester("testUpdateLockableGroupsWithRenewableLock"));
  suite.addTest(new GroupsTester("testContains"));

//	Add more tests here.
//  NB: Order of tests is not guaranteed.

    return suite;
}
/**
 */
protected void tearDown()
{
    try
    {
        testEntityKeys = null;
        testEntities = null;
        deleteTestGroups();
        deleteTestEntityType();

        clearGroupCache();

    }
    catch (Exception ex) { print("EntityCacheTester.tearDown(): " + ex.getMessage());}
}
/**
 */
public void testAddAndDeleteGroups() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testAddAndDeleteGroups() *****" + CR);
    String msg = null;

    msg = "Creating a new IEntityGroup.";
    print(msg);
    IEntityGroup newGroup = getNewGroup();
    assertNotNull(msg, newGroup);

    print("Now updating " + newGroup);
    newGroup.setName("Test");
    newGroup.setCreatorID("de3");
    newGroup.update();

    print("Now retrieving group just created from the store.");
    String key = newGroup.getKey();
    IEntityGroup retrievedGroup = getService().findGroup(key);

    msg = "Testing retrieved group.";
    print(msg);
    assertEquals(msg, newGroup, retrievedGroup);

    print("Now deleting group just created from the store.");
    retrievedGroup.delete();

    print("Attempting to retrieve deleted group from the store.");
    retrievedGroup = getService().findGroup(key);
    assertNull(msg, retrievedGroup);

    print(CR + "***** LEAVING GroupsTester.testAddAndDeleteGroups() *****" + CR);

}
/**
 */
public void testAddAndDeleteMembers() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testAddAndDeleteMembers() *****" + CR);
    String msg = null;
    Class type = TEST_ENTITY_CLASS;
    int totNumGroups = 3;
    int totNumEntities = 5;
    IEntityGroup[] groups = new IEntityGroup[totNumGroups];
    IEntity[] entities = new IEntity[totNumEntities];
    IGroupMember[] groupMembers = null;
    Iterator itr = null;
    ArrayList list = null;
    int idx = 0;

    msg = "Creating " + totNumGroups + " new groups.";
    print(msg);
    for (idx=0; idx<totNumGroups; idx++)
    {
        groups[idx] = getNewGroup();
        assertNotNull(msg, groups[idx]);
    }
    IEntityGroup rootGroup = groups[0];
    IEntityGroup childGroup = groups[1];


    msg = "Adding " + (totNumGroups - 1) + " to root group.";
    print(msg);
    for(idx=1; idx<totNumGroups; idx++)
        { rootGroup.addMember(groups[idx]); }

    msg = "Retrieving members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 1), list.size());

    msg = "Adding " + (totNumEntities - 2) + " to root group.";
    print(msg);
    for(idx=0; idx<(totNumEntities - 2) ; idx++)
        { rootGroup.addMember(testEntities[idx]); }

    msg = "Retrieving members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 1 + totNumEntities - 2), list.size());

    msg = "Adding 2 entities to child group.";
    print(msg);
    childGroup.addMember(testEntities[totNumEntities - 1]);
    childGroup.addMember(testEntities[totNumEntities]);

    msg = "Retrieving ALL members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getAllMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 1 + totNumEntities), list.size());

    msg = "Deleting child group from root group.";
    print(msg);
    rootGroup.removeMember(childGroup);

    msg = "Retrieving ALL members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getAllMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 2 + totNumEntities - 2 ), list.size());


    print(CR + "***** LEAVING GroupsTester.testAddAndDeleteMembers() *****" + CR);

}
/**
 */
public void testContains() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testContains() *****" + CR);
    String msg = null;
    Class type = TEST_ENTITY_CLASS;
    int totNumEntities = 1;
    IEntityGroup containingGroup, childGroup, dupContainingGroup = null;
    IEntity[] entities = new IEntity[totNumEntities];
    IGroupMember[] groupMembers = null;
    Iterator itr = null;
    ArrayList list = null;
    int idx = 0;
    boolean testValue = false;

    msg = "Creating new parent group.";
    print(msg);
    containingGroup = getNewGroup();
    assertNotNull(msg, containingGroup);

    msg = "Creating new child group.";
    print(msg);
    childGroup = getNewGroup();
    assertNotNull(msg, childGroup);

    msg = "Creating " + totNumEntities + " new entities.";
    print(msg);
    for(idx=0; idx<totNumEntities; idx++)
        { entities[idx] = getNewEntity("E" + idx); }


    msg = "Adding " + (totNumEntities) + " to containing group.";
    print(msg);
    for(idx=0; idx<totNumEntities; idx++)
        { containingGroup.addMember(entities[idx]); }

    msg = "Testing if containing group contains entities.";
    print(msg);
    for(idx=0; idx<totNumEntities; idx++)
    {
        testValue = containingGroup.contains(entities[idx]);
        assertTrue(msg, testValue);
    }

    msg = "Adding child group to containing group.";
    print(msg);
    containingGroup.addMember(childGroup);

    msg = "Testing if containing group contains child group.";
    print(msg);
    testValue = containingGroup.contains(childGroup);
    assertTrue(msg, testValue);

    msg = "Updating containing group.";
    print(msg);
    containingGroup.update();

    msg = "Getting duplicate containing group.";
    print(msg);
    dupContainingGroup = findGroup(containingGroup.getKey());
    assertNotNull(msg,dupContainingGroup);

    msg = "Testing if RETRIEVED containing group contains entities.";
    print(msg);
    for(idx=0; idx<totNumEntities; idx++)
    {
        testValue = dupContainingGroup.contains(entities[idx]);
        assertTrue(msg, testValue);
    }

    msg = "Testing if RETRIEVED containing group contains child group.";
    print(msg);
    testValue = dupContainingGroup.contains(childGroup);
    assertTrue(msg, testValue);

    msg = "Deleting containing group from db.";
    print(msg);
    containingGroup.delete();

    print(CR + "***** LEAVING GroupsTester.testContains() *****" + CR);
}
/**
 */
public void testGroupMemberUpdate() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testGroupMemberUpdate() *****" + CR);
    String msg = null;

    Iterator itr;
    Collection list;
    int idx = 0;
    Exception e = null;

    int numAddedEntities = 10;
    int numDeletedEntities = 5;

    print("Creating 2 new groups.");

    IEntityGroup parent = getNewGroup(); parent.setName("parent"); parent.setCreatorID("de3");
    String parentKey = parent.getKey();
    IEntityGroup child  = getNewGroup(); child.setName("child");   child.setCreatorID("de3");
    String childKey = child.getKey();

    print("Adding " + child + " to " + parent);
    parent.addMember(child);

    print("Adding " + numAddedEntities + " members to " + child);
    for(idx=0; idx<numAddedEntities; idx++)
        { child.addMember(testEntities[idx]); }

    msg = "Retrieving members from " + child;  // child should have numAddedEntities group members.
    print(msg);
    list = getGroupMembers(child);
    assertEquals(msg, (numAddedEntities), list.size());

    msg = "Retrieving members from " + parent;  // parent should have numAddedEntities + 1 group members.
    print(msg);
    list = getAllGroupMembers(parent);
    assertEquals(msg, (numAddedEntities + 1), list.size());

    print("Now updating " + parent + " and " + child);
    child.update();
    parent.update();

    msg = "Retrieving " + parent + " and " + child + " from db.";
    print(msg);
    IEntityGroup retrievedParent = getService().findGroup(parentKey);
    IEntityGroup retrievedChild = getService().findGroup(childKey);
    assertEquals(msg, parent, retrievedParent);
    assertEquals(msg, child, retrievedChild);

    // retrievedChild should have numAddedEntities group members.
    msg = "Retrieving members from " + retrievedChild;
    print(msg);
    list = getAllGroupMembers(retrievedChild);
    assertEquals(msg, numAddedEntities, list.size());

    // retrievedParent should have numAddedEntities + 1 group members.
    msg = "Retrieving members from " + retrievedParent;
    print(msg);
    list = getAllGroupMembers(retrievedParent);
    assertEquals(msg, (numAddedEntities + 1), list.size());

    print("Deleting " + numDeletedEntities + " members from " + retrievedChild);
    for(idx=0; idx<numDeletedEntities; idx++)
        { retrievedChild.removeMember(testEntities[idx]); }

    // retrievedChild should have (numAddedEntities - numDeletedEntities) members.
    msg = "Retrieving members from " + retrievedChild;
    print(msg);
    list = getAllGroupMembers(retrievedChild);
    assertEquals(msg, (numAddedEntities - numDeletedEntities), list.size());

    msg = "Adding back one member to " + retrievedChild;
    print(msg);
    retrievedChild.addMember(testEntities[0]);

    // retrievedChild should have (numAddedEntities - numDeletedEntities + 1) members.
    msg = "Retrieving members from " + retrievedChild;
    print(msg);
    list = getAllGroupMembers(retrievedChild);
    assertEquals(msg, (numAddedEntities - numDeletedEntities + 1), list.size());

    int numChildMembers = list.size();
    print("Now updating " + retrievedChild);
    retrievedChild.update();

    msg = "Re-Retrieving " + retrievedChild + " from db.";
    print(msg);
    IEntityGroup reRetrievedChild = getService().findGroup(childKey);
    assertEquals(msg, retrievedChild, reRetrievedChild);

    // re-RetrievedChild should have (numAddedEntities - numDeletedEntities + 1) members.
    msg = "Retrieving members from " + reRetrievedChild;
    print(msg);
    list = getAllGroupMembers(reRetrievedChild);
    assertEquals(msg, numChildMembers, list.size());

    // Remove parent and child groups from db.
    msg = "Deleting " + retrievedParent + " and " + reRetrievedChild + " from db.";
    print(msg);
    retrievedParent.delete();
    reRetrievedChild.delete();

    IEntityGroup deletedParent = getService().findGroup(parentKey);
    IEntityGroup deletedChild = getService().findGroup(childKey);
    assertNull(msg, deletedParent);
    assertNull(msg, deletedChild);

    print(CR + "***** LEAVING GroupsTester.testGroupMemberUpdate() *****" + CR);

}
/**
 */
public void testGroupMemberValidation() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testGroupMemberValidation() *****" + CR);
    String msg = null;

    Iterator itr;
    Collection list;
    int idx = 0;
    Exception e = null;

    IEntityGroup parent = getNewGroup(); parent.setName("parent"); parent.setCreatorID("de3");
    IEntityGroup child  = getNewGroup(); child.setName("child");   child.setCreatorID("de3");
    IEntityGroup child2 = getNewGroup(); child2.setName("child");  child2.setCreatorID("de3");

    IEntity entity1 = getNewEntity("child");
    IEntity entity2 = getNewEntity("child");
    IEntity ipersonEntity = getService().getEntity("00000", IPERSON_CLASS);


    msg = "Adding " + child + " to " + parent;
    print(msg);
    parent.addMember(child);

    msg = "Retrieving members from " + parent;  // parent should have 1 group member.
    print(msg);
    list = getGroupMembers(parent);
    assertEquals(msg, 1, list.size());

    // Test adding a group with a duplicate name.
    msg = "Adding " + child2 + " to " + parent + " (should fail).";
    print(msg);
    try { parent.addMember(child2); }
    catch (GroupsException ge) {e = ge;}
    assertNotNull(msg, e);

    msg = "Retrieving members from " + parent;  // parent should STILL have 1 group member.
    print(msg);
    list = getGroupMembers(parent);
    assertEquals(msg, 1, list.size());

    msg = "Adding renamed " + child2 + " to " + parent + " (should succeed).";
    print(msg);
    child2.setName("child2");
    try { parent.addMember(child2); e=null;}
    catch (GroupsException ge) {e=ge;}
    assertNull(msg, e);

    msg = "Retrieving members from " + parent;  // parent should now have 2 group members.
    print(msg);
    list = getGroupMembers(parent);
    assertEquals(msg, 2, list.size());

    // Test adding an ENTITY with the same name as a member GROUP.
    msg = "Adding entity w/same name as child group to " + parent;
    print(msg);
    parent.addMember(entity1);

    msg = "Retrieving members from " + parent;  // parent should now have 3 group members.
    print(msg);
    list = getGroupMembers(parent);
    assertEquals(msg, 3, list.size());

    // Test adding a group member with a duplicate key.
    msg = "Adding another entity w/same name as child group to " + parent + " (should fail).";
    print(msg);
    try { parent.addMember(entity2); e = null;}
    catch (GroupsException ge) {e = ge;}
    assertNotNull(msg, e);

    msg = "Retrieving members from " + parent;  // parent should still have 3 group members.
    print(msg);
    list = getGroupMembers(parent);
    assertEquals(msg, 3, list.size());

    // Test adding a group member with a different type:
    msg = "Adding an entity of different type to " + parent;
    print(msg);
    try { parent.addMember(ipersonEntity); e = null; }
    catch (GroupsException ge) {e = ge;}
    assertNotNull(msg, e);

    msg = "Retrieving members from " + parent;  // parent should still have 3 group members.
    print(msg);
    list = getGroupMembers(parent);
    assertEquals(msg, 3, list.size());

    // Test adding a circular reference.
    try { child.addMember(parent); e = null; }
    catch (GroupsException ge) { e = ge; }
    assertNotNull(msg, e);

    msg = "Retrieving members from " + child;  // child should have 0 members.
    print(msg);
    list = getGroupMembers(child);
    assertEquals(msg, 0, list.size());

    print(CR + "***** LEAVING GroupsTester.testGroupMemberValidation() *****" + CR);

}
/**
 */
public void testRetrieveParentGroups() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testRetrieveParentGroups() *****" + CR);
    String msg = null;
    int numAllGroups = 10;
    int numContainingGroups = 8;

    IEntityGroup[] allGroups = new IEntityGroup[numAllGroups];
    IEntity testEntity = testEntities[0];
    Iterator it = null;
    Collection list = null;
    int idx = 0;

    msg = "Creating " + numAllGroups + " new groups...";
    print(msg);
    for (idx=0; idx < numAllGroups; idx++)
    {
        allGroups[idx] = getNewGroup();
        assertNotNull(msg, allGroups[idx]);
        allGroups[idx].setName("Parent Group " + idx);
        allGroups[idx].setCreatorID("de3");
        allGroups[idx].update();
        print("Group " + allGroups[idx].getName() + " created.");
    }
    msg = numAllGroups + " new groups created";
    print(msg);

    msg = "Adding " + testEntity + " to " + numContainingGroups + " containing groups.";
    print(msg);
    for (idx=0; idx<numContainingGroups; idx++)
    {
        allGroups[idx].addMember(testEntity);
        allGroups[idx].update();
    }

    msg = "Getting containing groups for " + testEntity;
    print(msg);
    list = new ArrayList();
    for (it = testEntity.getContainingGroups(); it.hasNext();)
        { list.add(it.next()); }
    assertEquals(msg, numContainingGroups, list.size());

    msg = "Adding parents to the immediate containing groups.";
    print(msg);
    for (idx=numContainingGroups; idx<numAllGroups; idx++)
    {
        IEntityGroup parent = allGroups[idx];
        IEntityGroup child = allGroups[idx - 1];
        msg = "Adding " + child + " to " + parent;
        print(msg);
        parent.addMember(child);
        parent.update();
    }

    msg = "Getting ALL containing groups for " + testEntity;
    print(msg);
    list = new ArrayList();
    for (it = testEntity.getAllContainingGroups(); it.hasNext();)
        { list.add(it.next()); }
    assertEquals(msg, numAllGroups, list.size());


    IEntity duplicateTestEntity = GroupService.getEntity(testEntity.getKey(), testEntity.getType());
    msg = "Getting ALL containing groups for DUPLICATE entity:" + testEntity;
    print(msg);
    list = new ArrayList();
    for (it = duplicateTestEntity.getAllContainingGroups(); it.hasNext();)
        { list.add(it.next()); }
    assertEquals(msg, numAllGroups, list.size());




    print(CR + "***** LEAVING GroupsTester.testRetrieveParentGroups() *****" + CR);

}
/**
 */
public void testUpdateLockableGroups() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testUpdateLockableGroups() *****" + CR);
    String msg = null;
    Class type = TEST_ENTITY_CLASS;
    int totNumGroups = 3;
    int totNumEntities = 5;
    IEntityGroup[] groups = new IEntityGroup[totNumGroups];
    IEntity[] entities = new IEntity[totNumEntities];
    IGroupMember[] groupMembers = null;
    Iterator itr = null;
    ArrayList list = null;
    int idx = 0;
    boolean testValue = false;
    Exception e = null;

    msg = "Creating " + totNumGroups + " new groups.";
    print(msg);
    for (idx=0; idx<totNumGroups; idx++)
    {
        groups[idx] = getNewGroup();
        groups[idx].update();
        assertNotNull(msg, groups[idx]);
        groups[idx].update();
    }

    msg = "Getting group keys.";
    print(msg);
    String[] groupKeys = new String[totNumGroups];
    for (idx=0; idx<totNumGroups; idx++)
    {
        groupKeys[idx] = groups[idx].getKey();
    }

    msg = "Retrieving lockable group for key " + groupKeys[0];
    print(msg);
    ILockableEntityGroup lockableGroup1 = findLockableGroup(groupKeys[0]);
    testValue = lockableGroup1.getLock().isValid();
    assertTrue(msg, testValue);

    msg = "Retrieving a duplicate lockable group for key " + groupKeys[0] + " (should FAIL)";
    print(msg);
    try
    {
        ILockableEntityGroup lockableGroup2 = findLockableGroup(groupKeys[0]);
    }
    catch (GroupsException ge) {e = ge;}
    assertNotNull(msg, e);
    e = null;

    msg = "Checking lock of first group";
    print(msg);
    testValue = lockableGroup1.getLock().isValid();
    assertTrue(msg, testValue);

    String oldName = lockableGroup1.getName();
    String newName = "NEW GROUP NAME";
    msg = "Update name of lockable group but do not commit.";
    print(msg);
    lockableGroup1.setName(newName);
    assertEquals(msg, newName, lockableGroup1.getName());

    msg = "Checking lock of first group";
    print(msg);
    testValue = lockableGroup1.getLock().isValid();
    assertTrue(msg, testValue);

    msg = "Retrieving duplicate group from service; change should NOT be visible.";
    print(msg);
    IEntityGroup nonLockableGroup = findGroup(groupKeys[0]);
    assertEquals(msg, oldName, nonLockableGroup.getName());

    msg = "Checking lock of first group";
    print(msg);
    testValue = lockableGroup1.getLock().isValid();
    assertTrue(msg, testValue);


    msg = "Committing change to lockable group";
    print(msg);
    lockableGroup1.update();
    testValue = lockableGroup1.getLock().isValid();
    assertTrue(msg, ! testValue);

    msg = "Retrieving duplicate group from service; change should be visible now.";
    print(msg);
    nonLockableGroup = findGroup(groupKeys[0]);
    assertEquals(msg, newName, nonLockableGroup.getName());

    msg = "Attempting to delete old version of group " + groupKeys[0] + " (should FAIL.)";
    print(msg);
    try
    {
        lockableGroup1.delete();
    }
    catch (GroupsException ge) {e = ge;}
    assertNotNull(msg, e);
    e = null;

    msg = "Attempting to delete NEW version of group " + groupKeys[0];
    print(msg);
    ILockableEntityGroup lockableGroup3 = findLockableGroup(groupKeys[0]);
    lockableGroup3.delete();
    nonLockableGroup = findGroup(groupKeys[0]);
    assertNull(msg, nonLockableGroup);

    print(CR + "***** LEAVING GroupsTester.testUpdateLockableGroups() *****" + CR);

}
/**
 */
public void testUpdateLockableGroupsWithRenewableLock() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testUpdateLockableGroupsWithRenewableLock() *****" + CR);
    String msg = null;
    Class type = TEST_ENTITY_CLASS;
    IEntityGroup group = null;
    boolean testValue = false;
    Exception e = null;
    String groupKey = null;

    msg = "Creating new group.";
    print(msg);
    group = getNewGroup();
    group.update();
    assertNotNull(msg, group);

    msg = "Getting group key.";
    print(msg);
    groupKey = group.getKey();

    msg = "Retrieving lockable group for key " + groupKey;
    print(msg);
    ILockableEntityGroup lockableGroup = findLockableGroup(groupKey);
    assertNotNull(msg, lockableGroup);

    msg = "Checking lock of first group";
    print(msg);
    testValue = lockableGroup.getLock().isValid();
    assertTrue(msg, testValue);

    String oldName = lockableGroup.getName();
    String newName = "NEW GROUP NAME";
    msg = "Updating name of lockable group but not committing.";
    print(msg);
    lockableGroup.setName(newName);
    assertEquals(msg, newName, lockableGroup.getName());

    msg = "Checking lock of first group";
    print(msg);
    testValue = lockableGroup.getLock().isValid();
    assertTrue(msg, testValue);

    msg = "Committing change to lockable group and renewing lock.";
    print(msg);
    lockableGroup.updateAndRenewLock();
    testValue = lockableGroup.getLock().isValid();
    assertTrue(msg, testValue);

    msg = "Retrieving duplicate group from service; change should be visible now.";
    print(msg);
    IEntityGroup nonLockableGroup = findGroup(groupKey);
    assertEquals(msg, newName, nonLockableGroup.getName());

    msg = "Update name of lockable group again.";
    print(msg);
    lockableGroup.setName(oldName);
    assertEquals(msg, oldName, lockableGroup.getName());

    msg = "Committing change to lockable group and renewing lock.";
    print(msg);
    lockableGroup.updateAndRenewLock();
    testValue = lockableGroup.getLock().isValid();
    assertTrue(msg, testValue);

    msg = "Attempting to delete lockable group " + groupKey;
    print(msg);
    lockableGroup.delete();
    nonLockableGroup = findGroup(groupKey);
    assertNull(msg, nonLockableGroup);

    print(CR + "***** LEAVING GroupsTester.testUpdateLockableGroupsWithRenewableLock() *****" + CR);

}
/**
 */
public void testUpdateMembersVisibility() throws Exception
{
    print(CR + "***** ENTERING GroupsTester.testUpdateMembersVisibility() *****" + CR);
    String msg = null;
    Class type = TEST_ENTITY_CLASS;
    int totNumGroups = 3;
    int totNumEntities = 5;
    IEntityGroup[] groups = new IEntityGroup[totNumGroups];
    IEntity[] entities = new IEntity[totNumEntities];
    IGroupMember[] groupMembers = null;
    Iterator itr = null;
    ArrayList list = null;
    int idx = 0;
    boolean testValue = false;

    msg = "Creating " + totNumGroups + " new groups.";
    print(msg);
    for (idx=0; idx<totNumGroups; idx++)
    {
        groups[idx] = getNewGroup();
        assertNotNull(msg, groups[idx]);
    }
    IEntityGroup rootGroup = groups[0];
    IEntityGroup childGroup = groups[1];


    msg = "Adding " + (totNumGroups - 1) + " to root group.";
    print(msg);
    for(idx=1; idx<totNumGroups; idx++)
        { rootGroup.addMember(groups[idx]); }

    msg = "Retrieving members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 1), list.size());

    msg = "Adding " + (totNumEntities - 2) + " to root group.";
    print(msg);
    for(idx=0; idx<(totNumEntities - 2) ; idx++)
        { rootGroup.addMember(testEntities[idx]); }

    msg = "Retrieving members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 1 + totNumEntities - 2), list.size());

    msg = "Adding 2 entities to child group.";
    print(msg);
    childGroup.addMember(testEntities[totNumEntities - 1]);
    childGroup.addMember(testEntities[totNumEntities]);

    msg = "Retrieving ALL members from root group.";
    print(msg);
    list = new ArrayList();
    for( itr=rootGroup.getAllMembers(); itr.hasNext(); )
        { list.add(itr.next()); }
    assertEquals(msg, (totNumGroups - 1 + totNumEntities), list.size());

    // At this point, the child group members should not yet be aware of their parents.
    msg = "Checking child groups for parents (should be none).";
    print(msg);
    list = new ArrayList();
    for(idx=1; idx<totNumGroups; idx++)
    {
        for (itr = groups[idx].getContainingGroups(); itr.hasNext();)
            { list.add(itr.next()); }
        assertEquals(msg, 0, list.size());
    }

    testValue = testEntities[0].isMemberOf(rootGroup);
    assertEquals(msg, false, testValue);

    // Update the parent group.  Its children should now be aware of it.
    msg = "Updating parent group.";
    print(msg);
    rootGroup.update();

    msg = "Checking child entity for membership in parent.";
    print(msg);
    testValue = testEntities[0].isMemberOf(rootGroup);
    assertEquals(msg, true, testValue);

    // Child group not yet updated.  Its child should still be unaware of it.
    msg = "Checking child entity for membership in child group.";
    print(msg);
    testValue = testEntities[totNumEntities].isMemberOf(childGroup);
    assertEquals(msg, false, testValue);

    // Update the child group.  Its children should now be aware of it.
    msg = "Updating child group.";
    print(msg);
    childGroup.update();

    msg = "Checking child entity for membership in child group.";
    print(msg);
    testValue = testEntities[totNumEntities].isMemberOf(childGroup);
    assertEquals(msg, true, testValue);

    // Child entity should now be aware of both of its parents.
    msg = "Checking child entity for ALL containing groups.";
    print(msg);
    list = new ArrayList();
    for (itr = testEntities[totNumEntities].getAllContainingGroups(); itr.hasNext();)
            { list.add(itr.next()); }
    assertEquals(msg, 2, list.size());



    print(CR + "***** LEAVING GroupsTester.testUpdateMembersVisibility() *****" + CR);

}
}

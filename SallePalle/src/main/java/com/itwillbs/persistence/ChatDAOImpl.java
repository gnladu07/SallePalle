package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.service.AdminServiceImpl;

@Repository
public class ChatDAOImpl implements ChatDAO {
	
	private static final Logger log 
		= LoggerFactory.getLogger(AdminServiceImpl.class);

    private static final String NAMESPACE = "com.itwillbs.mapper.ChatMapper.";
    @Inject private SqlSession sqlSession;

    @Override
    public int findRoom(int trade_id, int buyer_id) {
    	log.debug(" ChatDAOImpl: findRoom() 실행!");
    	
        Map<String, Integer> paramMap = new HashMap<>();
        paramMap.put("trade_id", trade_id);
        paramMap.put("buyer_id", buyer_id);
        
        log.debug(" ChatDAOImpl: findRoom() 끝!");
        return sqlSession.selectOne(NAMESPACE + "findRoom", paramMap);
    }

    @Override
    public void createRoom(ChatRoomVO vo) {
    	log.debug(" ChatDAOImpl: createRoom() 실행!");
        sqlSession.insert(NAMESPACE + "createRoom", vo);
        log.debug(" ChatDAOImpl: createRoom() 끝!");
    }

    @Override
    public void insertMessage(ChatMessageVO vo) {
    	log.debug(" ChatDAOImpl: insertMessage() 실행!");
        sqlSession.insert(NAMESPACE + "insertMessage", vo);
        log.debug(" ChatDAOImpl: insertMessage() 끝!");
    }

    @Override
    public List<ChatMessageVO> getMessagesByRoomId(int room_id) {
    	log.debug(" ChatDAOImpl: getMessagesByRoomId() 실행!");
    	log.debug(" ChatDAOImpl: getMessagesByRoomId() 끝!");
        return sqlSession.selectList(NAMESPACE + "getMessagesByRoomId", room_id);
    }

    @Override
    public List<ChatRoomVO> getRoomList(int member_id) {
    	log.debug(" ChatDAOImpl: getRoomList() 실행!");
    	log.debug(" ChatDAOImpl: getRoomList() 끝!");
        return sqlSession.selectList(NAMESPACE + "getRoomList", member_id);
    }

	@Override
	public ChatRoomVO getRoom(int room_id) {
		log.debug(" ChatDAOImpl: getRoom() 실행!");
    	log.debug(" ChatDAOImpl: getRoom() 끝!");
		return sqlSession.selectOne(NAMESPACE + "getRoom", room_id);
	}
	
	@Override
    public void deleteChatMessages(int room_id) throws Exception {
		log.debug(" ChatDAOImpl: deleteChatMessages() 실행!");
        sqlSession.delete(NAMESPACE + "deleteChatMessages", room_id);
        log.debug(" ChatDAOImpl: deleteChatMessages() 끝!");
    }

    @Override
    public void deleteChatRoom(int room_id) throws Exception {
    	log.debug(" ChatDAOImpl: deleteChatRoom() 실행!");
        sqlSession.delete(NAMESPACE + "deleteChatRoom", room_id);
        log.debug(" ChatDAOImpl: deleteChatRoom() 끝!");
    }

    @Override
    public void markMessagesAsRead(Map<String, Object> paramMap) throws Exception {
    	log.debug(" ChatDAOImpl: markMessagesAsRead() 실행!");
        sqlSession.update(NAMESPACE + "markMessagesAsRead", paramMap);
        log.debug(" ChatDAOImpl: markMessagesAsRead() 끝!");
    }

    @Override
    public List<ChatRoomVO> getChatHistoryLog(int member_id) throws Exception {
    	log.debug(" ChatDAOImpl: getChatHistoryLog() 실행!");
    	log.debug(" ChatDAOImpl: getChatHistoryLog() 끝!");
        return sqlSession.selectList(NAMESPACE + "getChatHistoryLog", member_id);
    }

    @Override
    public void flagChatRoom(int room_id) throws Exception {
    	log.debug(" ChatDAOImpl: flagChatRoom() 실행!");
        sqlSession.update(NAMESPACE + "flagChatRoom", room_id);
        log.debug(" ChatDAOImpl: flagChatRoom() 끝!");
    }

    @Override
    public List<ChatRoomVO> getAdminChatList() throws Exception {
    	log.debug(" ChatDAOImpl: getAdminChatList() 실행!");
    	log.debug(" ChatDAOImpl: getAdminChatList() 끝!");
        return sqlSession.selectList(NAMESPACE + "getAdminChatList");
    }

    @Override
    public void adminSoftCloseRoom(int room_id) throws Exception {
    	log.debug(" ChatDAOImpl: adminSoftCloseRoom() 실행!");
        sqlSession.update(NAMESPACE + "adminSoftCloseRoom", room_id);
        log.debug(" ChatDAOImpl: adminSoftCloseRoom() 끝!");
    }

    @Override
    public List<ChatRoomVO> getAdminClosedChatList() throws Exception {
    	log.debug(" ChatDAOImpl: getAdminClosedChatList() 실행!");
    	log.debug(" ChatDAOImpl: getAdminClosedChatList() 끝!");
        return sqlSession.selectList(NAMESPACE + "getAdminClosedChatList");
    }


}